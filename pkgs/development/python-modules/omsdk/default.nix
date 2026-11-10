{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pysnmp,
  pyyaml,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "omsdk";
  version = "1.2.519";
  # PyPI only ships a wheel and the upstream GitHub repository is gone
  format = "wheel";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";
    hash = "sha256-w3GXhYce4oJszi315+b90Zmj2OpFyhITqkpZVD/U5EQ=";
  };

  dependencies = [
    pysnmp
    pyyaml
    requests
  ];

  pythonRemoveDeps = [
    # only used for `past.builtins.long`, which is replaced below;
    # python3Packages.future is disabled on Python >= 3.13
    "future"
    # backport of a module that is part of the standard library
    "ipaddress"
    # not packaged and never imported
    "pysnmp_mibs"
  ];

  postInstall = ''
    for f in omdrivers/lifecycle/iDRAC/iDRAC{Config,Streaming}.py; do
      substituteInPlace "$out/${python.sitePackages}/$f" \
        --replace-fail "from past.builtins import long" "long = int"
    done
  '';

  pythonImportsCheck = [
    "omsdk"
    "omsdk.sdkinfra"
    "omsdk.sdkcreds"
    "omsdk.sdkfile"
    "omsdk.sdkprotopref"
    "omsdk.http.sdkwsmanbase"
    "omdrivers"
    "omdrivers.enums.iDRAC.iDRAC"
    "omdrivers.types.iDRAC.RAID"
    "omdrivers.lifecycle.iDRAC.iDRACConfig"
    "omdrivers.lifecycle.iDRAC.iDRACStreaming"
  ];

  meta = {
    description = "Dell OpenManage Python SDK for managing PowerEdge servers and chassis";
    longDescription = ''
      Python library to automate the lifecycle management of Dell PowerEdge
      servers through the iDRAC's Redfish and WS-Man interfaces. It is used by
      the dellemc.openmanage Ansible collection.
    '';
    homepage = "https://pypi.org/project/omsdk/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ leonardpahlke ];
  };
})
