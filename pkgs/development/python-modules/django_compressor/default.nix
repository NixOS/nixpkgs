{ stdenv, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django_appconf }:
buildPythonPackage rec {
    pname = "django_compressor";
    version = "2.1.1";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1s42dkq3qp1niaf69markd7m3ljgf2bspyz2nk0sa07f8q04004j";
    };

    # Need to setup django testing
    doCheck = false;

    propagatedBuildInputs = [ rcssmin rjsmin django_appconf ];

    meta = with stdenv.lib; {
      description = "Compresses linked and inline JavaScript or CSS into single cached files";
      homepage = http://django-compressor.readthedocs.org/en/latest/;
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
}
