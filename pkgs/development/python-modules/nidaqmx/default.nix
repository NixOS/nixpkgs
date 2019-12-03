{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, numpy
, pytestCheckHook
, pykka
, enum34
, pythonOlder

# NI libs
, nidaqmx
}:

buildPythonPackage rec {
  pname = "nidaqmx";
  version = src.rev;

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

  checkInputs = [
    pytestCheckHook
    pykka
  ];

  postPatch = ''
    substituteInPlace nidaqmx/_lib.py \
      --replace "find_library('nidaqmx')" "\"${nidaqmx.packages.libnidaqmx}/lib/x86_64-linux-gnu/libnidaqmx.so.1\""
  '';

  dontUseSetuptoolsCheck = true;

  # Older pytest is needed
  # https://github.com/ni/nidaqmx-python/issues/80
  # Fixture "x_series_device" called directly. Fixtures are not meant to be called directly
  doCheck = false;

  pythonCheckImports = [
    "nidaqmx.task"
  ];

  meta = {
    description = "API for interacting with the NI-DAQmx driver";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
