{ stdenv, fetchFromGitHub,
  # perl, which, nettools,
  sbcl }:

let hashes = {
  "8.0" = "1x1giy2c1y6krg3kf8pf9wrmvk981shv0pxcwi483yjqm90xng4r";
};
in stdenv.mkDerivation rec {
  name = "acl2-${version}";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "acl2-devel";
    repo = "acl2-devel";
    rev = "${version}";
    sha256 = hashes."${version}";
  };

  buildInputs = [ sbcl
    # which perl nettools
  ];

  enableParallelBuilding = true;

  phases = "unpackPhase installPhase";

  installSuffix = "acl2";

  installPhase = ''
    mkdir -p $out/share/${installSuffix}
    mkdir -p $out/bin
    cp -R . $out/share/${installSuffix}
    cd $out/share/${installSuffix}

    # make ACL2 image
    make LISP=${sbcl}/bin/sbcl

    # The community books don't build properly under Nix yet.
    rm -rf books
    #make ACL2=$out/share/saved_acl2 USE_QUICKLISP=1 regression-everything

    cp saved_acl2 $out/bin/acl2
  '';

  meta = {
    description = "An interpreter and a prover for a Lisp dialect";
    longDescription = ''
      ACL2 is a logic and programming language in which you can model
      computer systems, together with a tool to help you prove
      properties of those models. "ACL2" denotes "A Computational
      Logic for Applicative Common Lisp".

      ACL2 is part of the Boyer-Moore family of provers, for which its
      authors have received the 2005 ACM Software System Award.

      NOTE: In nixpkgs, the community books that usually ship with
      ACL2 have been removed because it is not currently possible to
      build them with Nix.
    '';
    homepage = http://www.cs.utexas.edu/users/moore/acl2/;
    downloadPage = https://github.com/acl2-devel/acl2-devel/releases;
    # There are a bunch of licenses in the community books, but since
    # they currently get deleted during the build, we don't mention
    # their licenses here.  ACL2 proper is released under a BSD
    # 3-clause license.
    #license = with stdenv.lib.licenses;
    #[ free bsd3 mit gpl2 llgpl21 cc0 publicDomain ];
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ kini raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
