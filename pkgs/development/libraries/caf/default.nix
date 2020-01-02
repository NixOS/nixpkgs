{ stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "actor-framework";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    rev = version;
    sha256 = "187r7vc4kpd0v6bb1y51zwqm9y1lh0m84vkwmrxn8rrp4bwdxlpj";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DCAF_NO_EXAMPLES:BOOL=TRUE"
  ];

  doCheck = true;
  checkTarget = "test";
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/lib
  '';

  meta = with stdenv.lib; {
    description = "An open source implementation of the actor model in C++";
    homepage = http://actor-framework.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bobakker tobim ];
  };
}
