{ lib
, rustPlatform
, fetchFromGitHub
}:

let
  # for whatever reason, rustPlatform fetches it the wrong way, so do it manually
  pcf = fetchFromGitHub {
    owner = "MinusKelvin";
    repo = "pcf";
    rev = "64cd95557f3cf56e11e4c91a963fce9700d85325";
    hash = "sha256-2/Y5thDN5fwthk+I/D7pORe7yQ1H0UpNjVvAeSYpD5Q=";
  };
in

rustPlatform.buildRustPackage {
  pname = "libcoldclear";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "26F-Studio";
    repo = "cold-clear";
    rev = "1564ce9ad14aa60f32bf9a5120594933b3501548";
    hash = "sha256-6fZpKHEJ0dsOTp755GLnxa/befCUJhjqA3Zna5UkKVo=";
  };

  # remove workspace cargo.toml so we don't load all of workspace's deps
  postPatch = ''
    rm Cargo.toml
    sed -i 's%git = "https://github.com/MinusKelvin/pcf", rev = "64cd955"%path = "../pcf"%g' */Cargo.toml
    ln -s ${pcf} pcf
    cd c-api
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "webutil-0.1.0" = "sha256-Zg98VmCUd/ZTlRTfTfkPJh4xX0QrepGxICbszebQw0I=";
    };
  };

  postInstall = ''
    mkdir -p $out/include
    cp coldclear.h $out/include
  '';

  meta = with lib; {
    description = "A Tetris AI";
    homepage = "https://github.com/26F-Studio/cold-clear";
    license = licenses.mpl20;
    maintainers = with maintainers; [ chayleaf ];
  };
}
