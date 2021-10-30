{ lib, buildPythonPackage, fetchPypi,
  rcssmin, rjsmin, django_appconf }:
buildPythonPackage rec {
    pname = "django_compressor";
    version = "2.4.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "3358077605c146fdcca5f9eaffb50aa5dbe15f238f8854679115ebf31c0415e0";
    };
    postPatch = ''
      substituteInPlace setup.py --replace 'rcssmin == 1.0.6' 'rcssmin' \
        --replace 'rjsmin == 1.0.12' 'rjsmin'
    '';

    # requires django-sekizai, which we don't have packaged yet
    doCheck = false;

    propagatedBuildInputs = [ rcssmin rjsmin django_appconf ];

    meta = with lib; {
      description = "Compresses linked and inline JavaScript or CSS into single cached files";
      homepage = "https://django-compressor.readthedocs.org/en/latest/";
      license = licenses.mit;
      maintainers = with maintainers; [ desiderius ];
    };
}
