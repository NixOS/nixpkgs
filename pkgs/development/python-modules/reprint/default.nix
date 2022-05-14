{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, backports_shutil_get_terminal_size
, colorama
}:

buildPythonPackage rec {
  pname = "reprint";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Yinzo";
    repo = pname;
    rev = "${version}";
    sha256 = "0jqqskpsi2d0953l4bwyd1id3nx3sqmhscfhq18z9gnwcbbl5lgp";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'backports.shutil_get_terminal_size'" ""
  '';

  propagatedBuildInputs = [
    six
    backports_shutil_get_terminal_size
    colorama
  ];

  pythonImportsCheck = [
    "reprint"
  ];

  meta = with lib; {
    description = "A Python 2/3 module for binding variables and refreshing multi-line output in terminal.";
    homepage = "https://github.com/Yinzo/reprint";
    license = licenses.asl20;
    maintainers = with maintainers; [ glittershark ];
  };
}
