{ stdenv, buildPythonPackage, fetchPypi, python, cftime, numpy, udunits }:
buildPythonPackage rec {
  pname = "cfunits";
  version = "3.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b5bq0zzgkfh1ih2q439gfd95rh7mb3r6y7al7f3lv0cnalslbbm";
  };

  postPatch = ''
    substituteInPlace cfunits/units.py \
      --replace "_libpath = ctypes.util.find_library('udunits2')" "_libpath = '${udunits}/lib/libudunits2.so.0'"
  '';

  checkPhase = ''
    cd cfunits
    ${python.interpreter} test/run_tests.py
  '';

  propagatedBuildInputs = [ cftime numpy udunits ];

  meta = with stdenv.lib; {
    description = "Interface to UNIDATA's UDUNITS-2 library with CF extensions";
    homepage = "https://ncas-cms.github.io/cfunits/";
    license = licenses.mit;
    maintainers = [ maintainers.jshholland ];
  };
}
