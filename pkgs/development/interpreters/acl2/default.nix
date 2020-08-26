{ stdenv, callPackage, fetchFromGitHub, writeShellScriptBin, substituteAll
, sbcl, bash, which, perl, nettools
, openssl, glucose, minisat, abc-verifier, z3, python2
, certifyBooks ? true
} @ args:

let
  # Disable immobile space so we don't run out of memory on large books; see
  # http://www.cs.utexas.edu/users/moore/acl2/current/HTML/installation/requirements.html#Obtaining-SBCL
  sbcl = args.sbcl.override { disableImmobileSpace = true; };

  # Wrap to add `-model` argument because some of the books in 8.3 need this.
  # Fixed upstream (https://github.com/acl2/acl2/commit/0359538a), so this can
  # be removed in ACL2 8.4.
  glucose = writeShellScriptBin "glucose" ''exec ${args.glucose}/bin/glucose -model "$@"'';

in stdenv.mkDerivation rec {
  pname = "acl2";
  version = "8.3";

  src = fetchFromGitHub {
    owner = "acl2-devel";
    repo = "acl2-devel";
    rev = "${version}";
    sha256 = "0c0wimaf16nrr3d6cxq6p7nr7rxffvpmn66hkpwc1m6zpcipf0y5";
  };

  libipasirglucose4 = callPackage ./libipasirglucose4 { };

  patches = [
    (substituteAll {
      src = ./0001-Fix-some-paths-for-Nix-build.patch;
      inherit bash libipasirglucose4;
      openssl = openssl.out;
    })
    ./0002-Restrict-RDTSC-to-x86.patch
  ];

  buildInputs = [
    # ACL2 itself only needs a Common Lisp compiler/interpreter:
    sbcl
  ] ++ stdenv.lib.optionals certifyBooks [
    # To build community books, we need Perl and a couple of utilities:
    which perl nettools
    # Some of the books require one or more of these external tools:
    openssl.out glucose minisat abc-verifier libipasirglucose4
    z3 (python2.withPackages (ps: [ ps.z3 ]))
  ];

  # NOTE: Parallel building can be memory-intensive depending on the number of
  # concurrent jobs.  For example, this build has been seen to use >120GB of
  # RAM on an 85 core machine.
  enableParallelBuilding = true;

  preConfigure = ''
    # When certifying books, ACL2 doesn't like $HOME not existing.
    export HOME=$(pwd)/fake-home
  '' + stdenv.lib.optionalString certifyBooks ''
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
  makeFlags="LISP=${sbcl}/bin/sbcl";

  doCheck = true;
  checkTarget = "mini-proveall";

  installPhase = ''
    mkdir -p $out/bin
    ln -s $out/share/${pname}/saved_acl2           $out/bin/${pname}
  '' + stdenv.lib.optionalString certifyBooks ''
    ln -s $out/share/${pname}/books/build/cert.pl  $out/bin/${pname}-cert
    ln -s $out/share/${pname}/books/build/clean.pl $out/bin/${pname}-clean
  '';

  preDistPhases = [ (if certifyBooks then "certifyBooksPhase" else "removeBooksPhase") ];

  certifyBooksPhase = ''
    # Certify the community books
    pushd $out/share/${pname}/books
    makeFlags="ACL2=$out/share/${pname}/saved_acl2"
    buildFlags="everything"
    buildPhase
    popd
  '';

  removeBooksPhase = ''
    # Delete the community books
    rm -rf $out/share/${pname}/books
  '';

  meta = with stdenv.lib; {
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
    homepage = "http://www.cs.utexas.edu/users/moore/acl2/";
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
