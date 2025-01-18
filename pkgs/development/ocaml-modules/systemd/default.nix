{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  systemdLibs,
}:
buildDunePackage {
  pname = "systemd";
  version = "1.3";
  src = fetchFromGitHub {
    owner = "juergenhoetzel";
    repo = "ocaml-systemd";
    rev = "1.3";
    hash = "sha256-/FV+mFhuB3mEZv34XZrA4gO6+QIYssXqurnvkNBTJ2o=";
  };
  minimalOCamlVersion = "4.06";
  propagatedBuildInputs = [ systemdLibs ];
  meta = with lib; {
    platform = platforms.linux;
    description = "OCaml module for native access to the systemd facilities";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.atagen ];
  };
}
