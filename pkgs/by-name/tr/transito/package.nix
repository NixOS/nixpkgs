{ lib
, buildGoModule
, fetchFromSourcehut
, pkg-config
, vulkan-headers
, libxkbcommon
, wayland
, xorg
, libGL
}:

buildGoModule rec {
  pname = "transito";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "transito";
    rev = "v${version}";
    hash = "sha256-EM7hnHZjchpRzjl+iCBeLqLcyZhIS2Tl9opDx/w7Dcw=";
  };

  proxyVendor = true;

  vendorHash = "sha256-8GLtZxn8q0VAmgs8fwqLNriKiRr2VjgvfFx9QdR4x5I=";

  doCheck = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    vulkan-headers
    libxkbcommon
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
    libGL
  ];

  ldflags = [
    "-X git.sr.ht/~mil/transito/uipages/pageconfig.Commit=${version}"
  ];

  tags = [
    "sqlite_math_functions"
  ];

  meta = with lib; {
    description = "Data-provider-agnostic public transportation app";
    homepage = "https://git.sr.ht/~mil/transito";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.trungtruong1 ];
    mainProgram = "transito";
    platforms = platforms.unix;
  };
}
