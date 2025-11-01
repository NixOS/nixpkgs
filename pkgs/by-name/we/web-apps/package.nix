{
  lib,
  fetchFromGitHub,
  openssl,
  git,
  cmake,
  rustPlatform,
  libxkbcommon,
  pkg-config,
  glib,
  gtk3,
  webkitgtk_4_1,
  wayland,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "web-apps";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    tag = version;
    hash = "sha256-vWEa6mSK8lhqHRU/Zgi2HUGIs37G7E28AEEWj7TSaPc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  cargoLock = {
    outputHashes = {
      "accesskit-0.16.0" = "sha256-uoLcd116WXQTu1ZTfJDEl9+3UPpGBN/QuJpkkGyRADQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-+8CGmBf1Gl9gnBDtuKtkzUE5rySebhH7Bsq/kNlJofY=";
      "cosmic-client-toolkit-0.1.0" = "sha256-KvXQJ/EIRyrlmi80WKl2T9Bn+j7GCfQlcjgcEVUxPkc=";
      "cosmic-config-0.1.0" = "sha256-vZpw0HC1NwuDSJgd1rOsJgJoCY5yU44wZd9gQpCyN0s=";
      "cosmic-freedesktop-icons-0.3.0" = "sha256-XAcoKxMp1fyclalkkqVMoO7+TVekj/Tq2C9XFM9FFCk=";
      "cosmic-settings-daemon-0.1.0" = "sha256-0KCw70FGecsRPpapC7YeOsxNFtWdIReqkm0hgTqmd0s=";
      "cosmic-text-0.14.2" = "sha256-LLuUqwUATVy1fcDzHcr+VcpmdpzBNkuGNhMqJ6GFuWA=";
      "dpi-0.1.1" = "sha256-zuX4cvJP67wR4SyWIfkqdxnEf+SUgBb0//1hpoZszRo=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-/ocK79Lr5ywP/bb5mrcm7eTzeBbwpOazojvFUsAjMKM=";
    };
  };

  buildInputs = [
    wayland
    glib
    libxkbcommon
    pkg-config
    openssl
    git
    gtk3
    webkitgtk_4_1
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/dev-heppen-webapps \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libxkbcommon
        ]
      }
  '';

  meta = {
    description = " Web applications at your fingertips.";
    homepage = "https://github.com/cosmic-utils/web-apps";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ berrij ];
  };
}
