{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "wmutils-opt";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "opt";
    rev = "v${version}";
    sha256 = "0gd05qsir1lnzfrbnfh08qwsryz7arwj20f886nqh41m87yqaljz";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Optional addons to wmutils";
    homepage = "https://github.com/wmutils/opt";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vifino ];
    platforms = lib.platforms.unix;
  };
}
