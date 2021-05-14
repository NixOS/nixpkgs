{ lib
, buildPythonPackage
, fetchPypi
, ansible-base
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
, withJunos ? false
, withNetbox ? false
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "3.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "096rbgz730njk0pg8qnc27mmz110wqrw354ca9gasb7rqg0f4d6a";
  };

  postPatch = ''
    # make ansible-base depend on ansible-collection, not the other way around
    sed -i '/ansible-base/d' setup.py
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
    homepage = "http://www.ansible.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
