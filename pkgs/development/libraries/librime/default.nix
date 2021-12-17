{ lib, stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gtest, capnproto, pkg-config, withExternalPlugins ? true,
  withPrivateHeaders ?  withExternalPlugins }:

stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = version;
    sha256 = "sha256-GzNMwyJR9PgJN0eGYbnBW6LS3vo4SUVLdyNG9kcEE18=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost glog leveldb marisa opencc libyamlcpp gtest capnproto ];

  cmakeFlags = with lib;
    optionals withExternalPlugins [ "-DENABLE_EXTERNAL_PLUGINS=ON"
                                    "-DRIME_PLUGINS_DIR=share/librime/plugins"
                                  ] ++
    optional withPrivateHeaders "-DINSTALL_PRIVATE_HEADERS=ON";

  patches = [ ./rime-plugin-dir.patch ];

  postInstall = lib.optionalString withPrivateHeaders ''
    # Some plugins need these headers.
    cp -r ../thirdparty/include/* $out/include
    '';

  meta = with lib; {
    homepage    = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.linux;
  };
}
