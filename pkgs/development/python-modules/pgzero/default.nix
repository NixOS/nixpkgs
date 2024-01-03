{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, enum34
, numpy
, pygame
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pgzero";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lordmauve";
    repo = "pgzero";
    rev = version;
    sha256 = "sha256-O3fQCs8lwyF42N2vmlJvkk/UqsNS3T4geDiHZj9lS3M=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    enum34
    numpy
    pygame
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  preCheck = ''
    # skip flaky tests
    rm -f test/test_sound_formats.py
  '';

  unittestFlagsArray = [
    "test/"
    "-v"
  ];

  pythonImportsCheck = [ "pgzero" ];

  meta = with lib; {
    description = "A zero-boilerplate 2D games framework";
    homepage = "https://github.com/lordmauve/pgzero";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ rookeur ];
  };
}
