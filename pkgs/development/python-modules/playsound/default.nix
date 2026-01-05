{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "playsound";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TaylorSMarks";
    repo = "playsound";
    rev = "v${version}";
    sha256 = "0jbq641lmb0apq4fy6r2zyag8rdqgrz8c4wvydzrzmxrp6yx6wyd";
  };

  doCheck = false;

  pythonImportsCheck = [ "playsound" ];

  meta = with lib; {
    homepage = "https://github.com/TaylorSMarks/playsound";
    description = "Pure Python, cross platform, single function module with no dependencies for playing sounds";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
