{ stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  name = "actor-framework-${version}";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = "${version}";
    sha256 = "0202nsdriigdh6sxi1k3hddvmf1x54qpykbvf2ghfhzyh0m1q7j2";
  };

  # See https://github.com/actor-framework/actor-framework/issues/545 and remove on next release that incorporates this
  patches = [ (fetchpatch {
    url    = "https://github.com/actor-framework/actor-framework/commit/c5a3ee26a6e76b28dd4226f35230b280f291386d.patch";
    sha256 = "1l0323cqyqlp3lvggm709fmfm6lk6av1smdbd420adhi3ksj2vhj";
  }) ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An open source implementation of the actor model in C++";
    homepage = http://actor-framework.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobakker ];
  };
}
