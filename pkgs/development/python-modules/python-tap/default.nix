{ lib, buildPythonPackage, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "python-tap";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "python-tap";
    repo = "tappy";
    rev = "v${version}";
    sha256 = "sha256-KKuIIG5IRsVIWxFv+amn/fo7CFMkQW3hbCA0ygJROyc=";
  };

  meta = with lib; {
    description = "Pythonic API to Linux uinput kernel module";
    homepage = "https://github.com/python-tap/tappy";
    license = licenses.bsd2;
    maintainers = with maintainers; [ avnik ];
  };
}
