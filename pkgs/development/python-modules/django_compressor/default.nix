{ stdenv, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django_appconf }:
buildPythonPackage rec {
    pname = "django_compressor";
    version = "2.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0kx7bclfa0sxlsz6ka70zr9ra00lks0hmv1kc99wbanx6xhirvfj";
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
