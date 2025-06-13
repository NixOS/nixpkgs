{
  callPackage,
  nixosTests,
  python3,
}:
let
  python = python3;

  common = callPackage ./common.nix { };

  frontend = callPackage ./frontend.nix { };
in
python.pkgs.buildPythonPackage {
  pname = "tandoor-recipes";

  inherit (common) version src;

  format = "other";

  patches = [
    ./pytest-xdist.patch # adapt pytest.ini the use $NIX_BUILD_CORES
  ];

  postPatch = ''
    # high parallelism let the tests easily fail with concurrent errors
    if (( $NIX_BUILD_CORES > 4)); then
      NIX_BUILD_CORES=4
    fi

    substituteInPlace pytest.ini --subst-var NIX_BUILD_CORES
  '';

  propagatedBuildInputs = with python.pkgs; [
    django
    cryptography
    django-annoying
    django-cleanup
    django-crispy-forms
    django-tables2
    djangorestframework
    drf-writable-nested
    django-oauth-toolkit
    bleach
    crispy-bootstrap4
    gunicorn
    lxml
    markdown
    pillow
    psycopg2
    python-dotenv
    requests
    six
    webdavclient3
    whitenoise
    icalendar
    pyyaml
    uritemplate
    beautifulsoup4
    microdata
    jinja2
    django-webpack-loader
    django-js-reverse
    django-allauth
    recipe-scrapers
    django-scopes
    django-treebeard
    django-cors-headers
    django-storages
    boto3
    django-prometheus
    django-hcaptcha
    python-ldap
    django-auth-ldap
    pyppeteer
    pytubefix
    aiohttp
    inflection
    redis
    requests-oauthlib
    pyjwt
    python3-openid
    python3-saml
  ];

  configurePhase = ''
    runHook preConfigure

    ln -sf ${frontend}/ cookbook/static/vue
    cp ${frontend}/webpack-stats.json vue/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Disable debug logging
    export DEBUG=0
    # Avoid dependency on django debug toolbar
    export DEBUG_TOOLBAR=0

    # See https://github.com/TandoorRecipes/recipes/issues/2043
    mkdir cookbook/static/themes/maps/
    touch cookbook/static/themes/maps/style.min.css.map
    touch cookbook/static/themes/bootstrap.min.css.map
    touch cookbook/static/css/bootstrap-vue.min.css.map

    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic_js_reverse
    ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib/tandoor-recipes
    chmod +x $out/lib/tandoor-recipes/manage.py
    makeWrapper $out/lib/tandoor-recipes/manage.py $out/bin/tandoor-recipes \
      --prefix PYTHONPATH : "$PYTHONPATH"

    # usually copied during frontend build (see vue.config.js)
    cp vue/src/sw.js $out/lib/tandoor-recipes/cookbook/templates/

    runHook postInstall
  '';

  nativeCheckInputs = with python.pkgs; [
    mock
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-django
    pytest-factoryboy
    pytest-html
    pytest-xdist
  ];

  # flaky
  disabledTests = [
    "test_add_duplicate"
    "test_reset_inherit_space_fields"
    "test_search_count"
    "test_url_import_regex_replace"
    "test_url_validator"
    "test_delete"
  ];

  passthru = {
    inherit frontend python;

    updateScript = ./update.sh;

    tests = {
      inherit (nixosTests) tandoor-recipes tandoor-recipes-script-name;
    };
  };

  meta = common.meta // {
    description = ''
      Application for managing recipes, planning meals, building shopping lists
      and much much more!
    '';
    mainProgram = "tandoor-recipes";
  };
}
