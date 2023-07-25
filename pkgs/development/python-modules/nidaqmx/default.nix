{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, numpy
, pytestCheckHook
, pykka
, enum34
, pythonOlder
, pythonAtLeast
}:

# Note we currently do not patch the path to the drivers
# because those are not available in Nixpkgs.
# https://github.com/NixOS/nixpkgs/pull/74980

buildPythonPackage rec {
  pname = "nidaqmx";
  version = src.rev;

  # 3.10 is not supported, upstream inactive
  disabled = pythonAtLeast "3.10";

  src = fetchFromGitHub {
    owner = "ni";
    repo = "nidaqmx-python";
    rev = "0.5.7";
    sha256 = "19m9p99qvdmvvqbwmqrqm6b50x7czgrj07gdsxbbgw04shf5bhrs";
  };

  propagatedBuildInputs = [
    numpy
    six
  ] ++ lib.optionals (pythonOlder "3.4") [
    enum34
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pykka
  ];

  dontUseSetuptoolsCheck = true;

  # Older pytest is needed
  # https://github.com/ni/nidaqmx-python/issues/80
  # Fixture "x_series_device" called directly. Fixtures are not meant to be called directly
  doCheck = false;

  pythonImportsCheck = [
    "nidaqmx.task"
  ];

  meta = {
    description = "API for interacting with the NI-DAQmx driver";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
