{ lib, buildPythonPackage, fetchFromGitHub, urllib3 }:

buildPythonPackage rec {
  pname = "downloader-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    sha256 = "0hjwy3qa6al6p35pv01sdl3szh7asf6vlmhwjbkpppn4zi239k0y";
  };

  propagatedBuildInputs = [ urllib3 ];

  # Disable checks due to networking (Errno 101)
  doCheck = false;

  pythonImportsCheck = [ "downloader_cli" ];

  meta = with lib; {
    description = "A simple downloader written in Python with an awesome customizable progressbar. ";
    homepage = "https://github.com/deepjyoti30/downloader-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
