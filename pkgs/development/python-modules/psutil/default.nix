{ stdenv
, buildPythonPackage
, fetchPypi, fetchpatch
, darwin
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e265c8f3da00b015d24b842bfeb111f856b13d24f2c57036582568dc650d6c3";
  };

  patches = [
    (fetchpatch {
      name = "disk_io_counters_fails.patch";
      url = "https://github.com/giampaolo/psutil/commit/8f99f3782663959062ee868bbfdbc336307a3a4d.diff";
      sha256 = "0j7wdgq8y20k27wcpmbgc1chd0vmbkxy8j0zwni1s4i7hyk64hmk";
    })
  ];

  # No tests in archive
  doCheck = false;

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.IOKit ];

  meta = {
    description = "Process and system utilization information interface for python";
    homepage = https://github.com/giampaolo/psutil;
    license = stdenv.lib.licenses.bsd3;
  };
}
