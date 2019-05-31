{ stdenv, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django_appconf }:
buildPythonPackage rec {
    pname = "django_compressor";
    version = "2.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "9616570e5b08e92fa9eadc7a1b1b49639cce07ef392fc27c74230ab08075b30f";
    };

    # Need to setup django testing
    doCheck = false;

    propagatedBuildInputs = [ rcssmin rjsmin django_appconf ];

    meta = with stdenv.lib; {
      description = "Compresses linked and inline JavaScript or CSS into single cached files";
      homepage = https://django-compressor.readthedocs.org/en/latest/;
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
}
