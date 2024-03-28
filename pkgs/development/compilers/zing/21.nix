{ callPackage }:
callPackage ./common.nix {
  dists = {
    aarch64-linux = {
      version = "24.02.0.0";
      jdkVersion = "21.0.2";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk21.0.2-linux_aarch64.tar.gz";
      hash =
        "sha512-TU5skD+tiJ0sijdQMXWQnqr+ckb5smOaoe8dvowb+YwD88+ebIdFSQ0RLvpa6ZFhpaVmOLdhcwuqKynNpQMo6A==";
    };
    x86_64-linux = {
      version = "24.02.0.0";
      jdkVersion = "21.0.2";
      url =
        "https://cdn.azul.com/zing-zvm/ZVM24.02.0.0/zing24.02.0.0-6-jdk21.0.2-linux_x64.tar.gz";
      hash =
        "sha512-AwRqgVaNcHXfkTJW+S3cTb59uNGgIHdQuAhxhgy8GUw3r0fk4OWMYMc57Qy3Aff/CU/lU+12kpE9FHWznNXdXA==";
    };
  };
}
