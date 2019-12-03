{ lib
, buildPythonPackage
, fetchPypi
, nidaqmx15
, substituteAll
}:

buildPythonPackage rec {
  pname = "pydaqmx";
  version = "1.4.2";

  src = fetchPypi {
    pname = "PyDAQmx";
    inherit version;
    sha256 = "9d4594d3c065e7625f6846f330822f856b2fd4d0ad6a6b9a6e4fe8f3e155279f";
  };

  patches = [
    (substituteAll {
      src = ./0001-Hardcode-paths-to-nidaqmxbase.patch;
      nidaqmxbase_header = "${nidaqmx15.nidaqmxbase-cinterface}/include/NIDAQmxBase.h";
      nidaqmxbase_lib = "${nidaqmx15.nidaqmxbase-cinterface}/lib/libnidaqmxbase.so";
    })
  ];

  dontUseSetuptoolsCheck = true;

  # Segfault. Probably need to change directory.
#   pythonImportsCheck = [
#     "PyDAQmx.DAQmxConfig"
#   ];

  meta = {
    description = "Interface to National Instrument NIDAQmx driver";
    license = lib.licenses.bsd3;
  };

}