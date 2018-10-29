{ stdenv
, buildPythonPackage
, fetchurl
, pythonOlder
}:

buildPythonPackage rec {
  name = "Django-${version}";
  version = "1.8.18";
  disabled = pythonOlder "2.7";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.8/${name}.tar.gz";
    sha256 = "1ishvbihr9pain0486qafb18dnb7v2ppq34nnx1s8f95bvfiqqf7";
  };

  # too complicated to setup
  doCheck = false;

  # patch only $out/bin to avoid problems with starter templates (see #3134)
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
    license = licenses.bsd0;
  };

}
