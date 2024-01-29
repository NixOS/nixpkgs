{ lib
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, fetchPypi
, bwa
, cffi
, zlib
}:

buildPythonPackage rec {
  pname = "bwapy";
  version = "0.1.4";
  format = "setuptools";

  # uses the removed imp module
  disabled = pythonOlder "3.6" || pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "090qwx3vl729zn3a7sksbviyg04kc71gpbm3nd8dalqp673x1npw";
  };
  postPatch = ''
    # replace bundled bwa
    rm -r bwa/*
    cp ${bwa}/lib/*.a ${bwa}/include/*.h bwa/

    substituteInPlace setup.py \
      --replace 'setuptools>=49.2.0' 'setuptools'
  '';

  buildInputs = [ zlib bwa ];

  propagatedBuildInputs = [ cffi ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "bwapy" ];

  meta = with lib; {
    homepage = "https://github.com/ACEnglish/bwapy";
    description = "Python bindings to bwa mem aligner";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ris ];
  };
}
