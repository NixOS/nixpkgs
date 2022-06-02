{ lib, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django-appconf }:

buildPythonPackage rec {
    pname = "django_compressor";
    version = "3.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "c4a87bf65f9a534cfaf1c321a000a229c24e50c6d62ba6ab089482db42e819d9";
    };
    postPatch = ''
      substituteInPlace setup.py \
        --replace 'rcssmin == 1.0.6' 'rcssmin' \
        --replace 'rjsmin == 1.1.0' 'rjsmin'
    '';

    # requires django-sekizai, which we don't have packaged yet
    doCheck = false;

    propagatedBuildInputs = [ rcssmin rjsmin django-appconf ];

    meta = with lib; {
      description = "Compresses linked and inline JavaScript or CSS into single cached files";
      homepage = "https://django-compressor.readthedocs.org/en/latest/";
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
}
