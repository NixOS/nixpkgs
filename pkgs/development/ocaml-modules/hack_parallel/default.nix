{ lib, fetchFromGitHub, buildDunePackage, core, core_unix ? null, pkg-config
, sqlite }:
buildDunePackage rec {
  pname = "hack_parallel";
  version = "1.0.1";
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "rvantonder";
    repo = "hack_parallel";
    rev = version;
    sha256 = "0qjlkw35r4q2cm0n2x0i73zvx1xgrp6axaia2nm8zxpm49mid629";
  };

  patches = [ ./hack_parallel.patch ];

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ core core_unix sqlite ];

  meta = {
    description =
      "Core parallel and shared memory library used by Hack, Flow, and Pyre";
    license = lib.licenses.mit;
    homepage = "https://github.com/rvantonder/hack_parallel";
  };
}
