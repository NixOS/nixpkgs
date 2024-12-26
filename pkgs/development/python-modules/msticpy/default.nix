{
  lib,
  attrs,
  azure-common,
  azure-core,
  azure-identity,
  azure-keyvault-secrets,
  azure-kusto-data,
  azure-mgmt-keyvault,
  azure-mgmt-subscription,
  azure-monitor-query,
  beautifulsoup4,
  bokeh,
  buildPythonPackage,
  cache,
  cryptography,
  deprecated,
  dnspython,
  fetchFromGitHub,
  folium,
  geoip2,
  html5lib,
  httpx,
  importlib-resources,
  ipython,
  ipywidgets,
  keyring,
  lxml,
  markdown,
  msal-extensions,
  msal,
  msrest,
  msrestazure,
  nest-asyncio,
  networkx,
  packaging,
  pandas,
  pydantic,
  pygments,
  pyjwt,
  pythonOlder,
  pyyaml,
  setuptools,
  tldextract,
  tqdm,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "msticpy";
  version = "2.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "msticpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-jYLAF+6yhZo74LYDaoA/+JTd05s6VCheYpHk6ilufBM=";
  };

  pythonRelaxDeps = [ "bokeh" ];

  build-system = [ setuptools ];

  dependencies = [
    attrs
    azure-common
    azure-core
    azure-identity
    azure-keyvault-secrets
    azure-kusto-data
    azure-mgmt-keyvault
    azure-mgmt-subscription
    azure-monitor-query
    beautifulsoup4
    bokeh
    cryptography
    deprecated
    dnspython
    folium
    geoip2
    html5lib
    httpx
    importlib-resources
    ipython
    ipywidgets
    keyring
    lxml
    msal
    msal-extensions
    msrest
    msrestazure
    nest-asyncio
    networkx
    packaging
    pandas
    pydantic
    pygments
    pyjwt
    pyyaml
    tldextract
    tqdm
    typing-extensions
    urllib3
  ];

  # Test requires network access
  doCheck = false;

  pythonImportsCheck = [ "msticpy" ];

  meta = {
    description = "Microsoft Threat Intelligence Security Tools";
    homepage = "https://github.com/microsoft/msticpy";
    changelog = "https://github.com/microsoft/msticpy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
