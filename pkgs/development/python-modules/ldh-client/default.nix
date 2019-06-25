{ stdenv, buildPythonPackage, fetchPypi, wrapGAppsHook, gobject-introspection, pygobject3, click, requests, networkmanager, networkmanager-openvpn}:

buildPythonPackage rec {
  pname = "ldh_client";
  version = "0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19dqnrz2rvv4mc4l41wrnrnnlbls37bjgbfqk12p283g5d4c5xnh";
  };

  postPatch = ''
      substituteInPlace "scripts/nm_tunnel_setup.py" --replace "/usr/lib/x86_64-linux-gnu/" "${networkmanager-openvpn}/lib/"
  '';

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [ gobject-introspection pygobject3 click requests networkmanager];

  meta = with stdenv.lib; {
    homepage = https://source.puri.sm/liberty/ldh_client;
    description = "user-facing command-line client for interacting with a Liberty Deckplan Host (LDH)";
    license = licenses.agpl3;
  };
}
