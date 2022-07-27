{ lib, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django-appconf }:

buildPythonPackage rec {
    pname = "django_compressor";
    version = "4.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-HbkbbQQpNjami9Eyjce7kNY2sClfZ7HMbU+hArn9JfY=";
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
