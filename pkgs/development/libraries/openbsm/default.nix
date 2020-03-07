{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "openbsm";
  version = "1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = lib.toUpper (builtins.replaceStrings ["." "-"] ["_" "_"] "${pname}-${version}");
    sha256 = "0b98359hd8mm585sh145ss828pg2y8vgz38lqrb7nypapiyqdnd1";
  };

  patches = lib.optional stdenv.isDarwin [ ./bsm-add-audit_token_to_pid.patch ];

  configureFlags = [ "ac_cv_file__usr_include_mach_audit_triggers_defs=no" ];

  meta = {
    description = "An implementation of Sun's Basic Security Module (BSM) security audit API and file format";
    homepage = "http://www.openbsm.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthewbauer ];
    license = lib.licenses.bsd2;
  };
}
