{ stdenv, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django_appconf }:
buildPythonPackage rec {
    pname = "django_compressor";
    version = "2.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "9616570e5b08e92fa9eadc7a1b1b49639cce07ef392fc27c74230ab08075b30f";
    };
    postPatch = ''
      substituteInPlace setup.py --replace 'rcssmin == 1.0.6' 'rcssmin' \
        --replace 'rjsmin == 1.0.12' 'rjsmin'
    '';

    # requires django-sekizai, which we don't have packaged yet
    doCheck = false;

    propagatedBuildInputs = [ rcssmin rjsmin django_appconf ];

    meta = with stdenv.lib; {
      description = "Compresses linked and inline JavaScript or CSS into single cached files";
      homepage = https://django-compressor.readthedocs.org/en/latest/;
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
}
