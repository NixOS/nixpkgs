{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "property-cached";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "property-cached";
    tag = "v${version}";
    hash = "sha256-8kityZ++1TS22Ff7a5x5bQi0QBaHsNaP4E/Man8A28A=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
  ];

  disabledTests = [
    # https://github.com/pydanny/cached-property/issues/131
    "test_threads_ttl_expiry"
  ];

  postPatch = ''
    # https://github.com/althonos/property-cached/pull/118
    rm -rf tests/test_coroutine_cached_property.py tests/test_async_cached_property.py

    # Remove use of pkg_resources
    substituteInPlace property_cached/__init__.py \
      --replace-fail 'import pkg_resources' "" \
      --replace-fail '__version__ = ' '__version__ = "${version}" # '
  '';

  pythonImportsCheck = [ "property_cached" ];

  meta = {
    description = "Decorator for caching properties in classes";
    homepage = "https://github.com/althonos/property-cached";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
