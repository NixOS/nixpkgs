{ lib, stdenv, callPackage, fetchFromGitHub, runCommandLocal, makeWrapper, substituteAll
, sbcl, bash, which, perl, hostname
, openssl, glucose, minisat, abc-verifier, z3, python2
, certifyBooks ? true
} @ args:

let
  # Disable immobile space so we don't run out of memory on large books, and
  # supply 2GB of dynamic space to avoid exhausting the heap while building the
  # ACL2 system itself; see
  # https://www.cs.utexas.edu/users/moore/acl2/current/HTML/installation/requirements.html#Obtaining-SBCL
  sbcl' = args.sbcl.override { disableImmobileSpace = true; };
  sbcl = runCommandLocal args.sbcl.name { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${sbcl'}/bin/sbcl $out/bin/sbcl \
      --add-flags "--dynamic-space-size 2000"
  '';

in stdenv.mkDerivation rec {
  pname = "acl2";
  version = "8.5";

  src = fetchFromGitHub {
    owner = "acl2-devel";
    repo = "acl2-devel";
    rev = version;
    sha256 = "12cv5ms1j3vfrq066km020nwxb6x2dzh12g8nz6xxyxysn44wzzi";
  };

  # You can swap this out with any other IPASIR implementation at
  # build time by using overrideAttrs (make sure the derivation you
  # use has a "libname" attribute so we can plug it into the patch
  # below).  Or, you can override it at runtime by setting the
  # $IPASIR_SHARED_LIBRARY environment variable.
  libipasir = callPackage ./libipasirglucose4 { };

  patches = [(substituteAll {
    src = ./0001-Fix-some-paths-for-Nix-build.patch;
    libipasir = "${libipasir}/lib/${libipasir.libname}";
    libssl = "${lib.getLib openssl}/lib/libssl${stdenv.hostPlatform.extensions.sharedLibrary}";
    libcrypto = "${lib.getLib openssl}/lib/libcrypto${stdenv.hostPlatform.extensions.sharedLibrary}";
  })];

  buildInputs = [
    # ACL2 itself only needs a Common Lisp compiler/interpreter:
    sbcl
  ] ++ lib.optionals certifyBooks [
    # To build community books, we need Perl and a couple of utilities:
    which perl hostname makeWrapper
    # Some of the books require one or more of these external tools:
    glucose minisat abc-verifier libipasir
    z3 (python2.withPackages (ps: [ ps.z3 ]))
  ];

  # NOTE: Parallel building can be memory-intensive depending on the number of
  # concurrent jobs.  For example, this build has been seen to use >120GB of
  # RAM on an 85 core machine.
  enableParallelBuilding = true;

  preConfigure = ''
    # When certifying books, ACL2 doesn't like $HOME not existing.
    export HOME=$(pwd)/fake-home
  '' + lib.optionalString certifyBooks ''
    # Some books also care about $USER being nonempty.
    export USER=nobody
  '';

  postConfigure = ''
    # ACL2 and its books need to be built in place in the out directory because
    # the proof artifacts are not relocatable. Since ACL2 mostly expects
    # everything to exist in the original source tree layout, we put it in
    # $out/share/${pname} and create symlinks in $out/bin as necessary.
    mkdir -p $out/share/${pname}
    cp -pR . $out/share/${pname}
    cd $out/share/${pname}
  '';

  preBuild = "mkdir -p $HOME";
  makeFlags = "LISP=${sbcl}/bin/sbcl ACL2_MAKE_LOG=NONE";

  doCheck = true;
  checkTarget = "mini-proveall";

  installPhase = ''
    mkdir -p $out/bin
    ln -s $out/share/${pname}/saved_acl2           $out/bin/${pname}
  '' + lib.optionalString certifyBooks ''
    ln -s $out/share/${pname}/books/build/cert.pl  $out/bin/${pname}-cert
    ln -s $out/share/${pname}/books/build/clean.pl $out/bin/${pname}-clean
  '';

  preDistPhases = [ (if certifyBooks then "certifyBooksPhase" else "removeBooksPhase") ];

  certifyBooksPhase = ''
    # Certify the community books
    pushd $out/share/${pname}/books
    makeFlags="ACL2=$out/share/${pname}/saved_acl2"
    buildFlags="all"
    buildPhase

    # Clean up some stuff to save space
    find -name '*@useless-runes.lsp' -execdir rm {} +  # saves ~1GB of space
    find -name '*.cert.out' -execdir gzip {} +         # saves ~400MB of space

    popd
  '';

  removeBooksPhase = ''
    # Delete the community books
    rm -rf $out/share/${pname}/books
  '';

  meta = with lib; {
    description = "An interpreter and a prover for a Lisp dialect";
    longDescription = ''
      ACL2 is a logic and programming language in which you can model computer
      systems, together with a tool to help you prove properties of those
      models. "ACL2" denotes "A Computational Logic for Applicative Common
      Lisp".

      ACL2 is part of the Boyer-Moore family of provers, for which its authors
      have received the 2005 ACM Software System Award.

      This package installs the main ACL2 executable ${pname}, as well as the
      build tools cert.pl and clean.pl, renamed to ${pname}-cert and
      ${pname}-clean.

    '' + (if certifyBooks then ''
      The community books are also included and certified with the `make
      everything` target.
    '' else ''
      The community books are not included in this package.
    '');
    homepage = "https://www.cs.utexas.edu/users/moore/acl2/";
    downloadPage = "https://github.com/acl2-devel/acl2-devel/releases";
    license = with licenses; [
      # ACL2 itself is bsd3
      bsd3
    ] ++ optionals certifyBooks [
      # The community books are mostly bsd3 or mit but with a few
      # other things thrown in.
      mit gpl2 llgpl21 cc0 publicDomain unfreeRedistributable
    ];
    maintainers = with maintainers; [ kini raskin ];
    platforms = platforms.all;
  };
}
