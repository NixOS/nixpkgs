{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "04yrm3kg8m77kh6z0b9yw4h43fm0d54wnyrd8lp5ddn487kawm5g";
  };

  configureFlags = [
    "--with-python=no"
  ];

  buildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
