{ lib
, fetchFromGitHub
, buildPythonPackage
, python3Packages
, pythonOlder
}:

buildPythonPackage rec {
  pname = "restinstance";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  flex = python3Packages.buildPythonPackage rec {
    pname = "flex";
    version = "6.14.1";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-KS7Wo38awKEK2GafXOuC6LoxBsFsVAkIIJJ7rIsLKes=";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [
      rfc3987
      click
      jsonpointer
      setuptools
      six
      strict-rfc3339
      pyyaml
      requests
      validate-email
   ];
  };

  genson = python3Packages.buildPythonPackage rec {
      pname = "genson";
      version = "v.1.2.2";
      src = fetchFromGitHub {
          owner = "wolverdude";
          repo = "GenSON";
          rev = "6bf083488de2804c3ff5bb03b05761ff31fac30c";
          sha256 = "sha256-3RaGY/F//Zt3aOH5ZO+jvRc6vn0+yT14MTYg6yCzO3w=";
      };
      doCheck = false;
  };

  src = fetchFromGitHub {
    owner = "asyrjasalo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ed0gJy0ns+Xs7DO0P7c8Jea9qI5A+tImUEG5Xz8Q3Ng=";
  };

  nativeCheckInputs = with python3Packages; [
    jsonschema
    nox
  ];

  checkPhase = ''
    nox -s test
  '';

  propagatedBuildInputs = with python3Packages; [
    flex
    genson
    jsonpath-ng
    pyyaml
    pygments
    pytz
    requests
    robotframework
    tzlocal
  ];

  pythonImportsCheck = [
    "REST"
  ];

  meta = with lib; {
    description = "Robot Framework library for RESTful JSON APIs";
    homepage = "https://asyrjasalo.github.io/RESTinstance";
    changelog = "https://github.com/asyrjasalo/RESTinstance/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ asyrjasalo ];
  };
}
