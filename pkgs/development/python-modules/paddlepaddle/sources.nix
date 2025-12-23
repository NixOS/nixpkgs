{
  version = "3.2.0";
  x86_64-linux = {
    platform = "manylinux1_x86_64";
    cpu = {
      cp312 = "sha256-LBf2daJevQZ19wP3uCd36pLbDDYL1Vpcay36rXvD8mA=";
      cp313 = "sha256-+irs0GFCQ1D2dwqD3aB5aR9yJGNc/ydurvTj4XRAA50=";
    };
    gpu = {
      cp312 = "sha256-YqxAWSvjhYOQUCiUPtjC3PdRxFeWGm/be8FxOrpaLZo=";
      cp313 = "sha256-TdFx5Ut3iOTRg8USL2eIHyRYv8QT4KrLBPdiPkaK+Nc=";
    };
  };
  aarch64-linux = {
    platform = "manylinux2014_aarch64";
    cpu = {
      cp312 = "sha256-TOUUEUr3Zxh1/Ekn6gBa+51dD9d3rrVqEHjSL39Os/s=";
      cp313 = "sha256-KqDlAvbdKE7aIcKH0yZFTfomrMqIwjqgrFgdHvmDGMU=";
    };
  };
  aarch64-darwin = {
    platform = "macosx_11_0_arm64";
    cpu = {
      cp312 = "sha256-rDNK9y0bDUnUyTPP1OtC1z7C3HpqryJIxihkPUGbbac=";
      cp313 = "sha256-OBhOHqf9e/A4g+ph9FYZuXEtksE60foWk06p4NbT6ZE=";
    };
  };
}
