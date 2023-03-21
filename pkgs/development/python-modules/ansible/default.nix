{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, jsonschema
, jxmlease
, ncclient
, netaddr
, paramiko
, pynetbox
, scp
, textfsm
, ttp
, xmltodict

# optionals
, withJunos ? false
, withNetbox ? false
}:

let
  pname = "ansible";
  version = "7.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YOLBpY8c6zShkLfDgPezOG0ec2kGGVSx+LjKPfdgY8w=";
  };

  postPatch = ''
    # we make ansible-core depend on ansible, not the other way around
    sed -Ei '/ansible-core/d' setup.py
  '';

  propagatedBuildInputs = lib.unique ([
    # Support ansible collections by default, make all others optional
    # ansible.netcommon
    jxmlease
    ncclient
    netaddr
    paramiko
    xmltodict
    # ansible.posix
    # ansible.utils
    jsonschema
    textfsm
    ttp
    xmltodict
    # ansible.windows

    # lots of collections with dedicated requirements.txt and pyproject.toml files,
    # add the dependencies for the collections you need conditionally and install
    # ansible using overrides to enable the collections you need.
  ] ++ lib.optionals (withJunos) [
    # ansible_collections/junipernetworks/junos/requirements.txt
    jxmlease
    ncclient
    paramiko
    scp
    xmltodict
  ] ++ lib.optionals (withNetbox) [
    # ansible_collections/netbox/netbox/pyproject.toml
    pynetbox
  ]);

  # don't try and fail to strip 48000+ non strippable files, it takes >5 minutes!
  dontStrip = true;

  # difficult to test
  doCheck = false;

  meta = with lib; {
    description = "Radically simple IT automation";
    homepage = "https://www.ansible.com";
    changelog = "https://github.com/ansible-community/ansible-build-data/blob/${version}/${lib.versions.major version}/CHANGELOG-v${lib.versions.major version}.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
