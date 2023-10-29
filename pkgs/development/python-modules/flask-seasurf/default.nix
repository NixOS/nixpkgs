{ lib, fetchFromGitHub, fetchpatch, buildPythonPackage, isPy3k, flask, mock, unittestCheckHook }:

buildPythonPackage rec {
  pname = "Flask-SeaSurf";
  version = "1.1.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-seasurf";
    rev = version;
    hash = "sha256-L/ZUEqqHmsyXG5eShcITII36ttwQlZN5GBngo+GcCdw=";
  };

  patches = [
    # Remove usage of deprecated flask._app_ctx_stack
    (fetchpatch {
      url = "https://github.com/maxcountryman/flask-seasurf/commit/9039764a4e44aeb1acb6ae7747deb438bee0826b.patch";
      hash = "sha256-bVYzJN6MXzH3fNMknd2bh+04JlPJRkU0cLcWv+Rigqc=";
    })
  ];

  postPatch = ''
    # - cookie_jar is private in werkzeug 2.3, so recreate the client instead
    # - set_cookie does not take a hostname argument anymore, use domain instead
    substituteInPlace test_seasurf.py \
      --replace '    client.cookie_jar.clear()' 'with self.app.test_client() as client:' \
      --replace "client.set_cookie('www.example.com', self.csrf._csrf_name, token)" "client.set_cookie(self.csrf._csrf_name, token, domain='www.example.com')" \
      --replace "c.delete('/foo/baz'," "c.delete('/foo/baz', content_type='application/json'," \

    # Headers need to specify a content type
    sed -i "s#\(post\|delete\)(\(u\?'[^']*'\(, headers=headers\)\?\))#\1(\2, content_type='application/json')#g" test_seasurf.py

    # Disable some tests
    sed -i "s#\(\(test_header_set_on_post\|test_https_good_referer\|test_https_referer_check_disabled\)(self):\)#\1\n        return#g" test_seasurf.py
  '';

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];

  pythonImportsCheck = [ "flask_seasurf" ];

  meta = with lib; {
    description = "A Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
