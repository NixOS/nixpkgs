{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "openbsm";
  name = "${pname}-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${lib.toUpper (builtins.replaceStrings ["." "-"] ["_" "_"] name)}";
    sha256 = "0b98359hd8mm585sh145ss828pg2y8vgz38lqrb7nypapiyqdnd1";
  };

  patches = [ ./bsm-add-audit_token_to_pid.patch ];

  meta = {
    homepage = http://www.openbsm.org/;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthewbauer ];
    license = lib.licenses.bsd2;
  };
}
