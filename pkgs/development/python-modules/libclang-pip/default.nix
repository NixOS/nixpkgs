{ stdenvNoCC
, lib
, buildPythonPackage
, fetchPypi
}:

let
  supported-platforms = {
    x86_64-linux = "manylinux2010_x86_64";
    x86_64-darwin = "macosx_10_9_x86_64";
    aarch64-darwin = "macosx_11_0_arm64";
    aarch64-linux = "manylinux2014_aarch64";
  };

  platform = let
    os = if stdenvNoCC.isDarwin then "darwin" else "linux";
    arch = if stdenvNoCC.isAarch64 then "aarch64" else "x86_64";
  in "${arch}-${os}";

in buildPythonPackage rec {
  # libclang is reserved by clang package
  pname = "libclan-pip";
  version = "16.0.6";
  format = "wheel";

  src = fetchPypi {
    inherit version format;

    pname = "libclang";
    platform = supported-platforms.${platform};
    sha256 = {
      x86_64-linux = "sha256-nc3HMJOXiLi2n/1tXXX+U2bj7gB/Hjapl5nsCwwAFJI=";
      x86_64-darwin = "sha256-2p5H68PwptkPsWnvJfn7zSm0pO+XqLDj46F4AK8UI/Q=";
      aarch64-darwin = "sha256-4aWtHoleVEPiBVaMhcBLRgjk6XPa5C9N/Zy0bIHRSGs=";
      aarch64-linux = "sha256-gTBIISBQBHagJxcfjzyN/CU2tZFxbupx/F2iLK4TExs=";
    }.${platform};
  };

  meta = {
    description = "Clang Python Bindings, mirrored from the official LLVM repo";
    homepage = "https://github.com/sighingnow/libclang";
    license = lib.licenses.asl20-llvm;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = builtins.attrNames supported-platforms;
  };
}
