{
  version = "3.3.0";
  x86_64-linux = {
    platform = "linux_x86_64";
    cpu = {
      cp312 = "sha256-PumW7ivy0rM+mGWHb7gv8Dy3uyJGzFqgAn7dapoGQOs=";
      cp313 = "sha256-iImCdPXNXi9OuvVjHUwAkn2dWEZaCDh1wiS0D5k1zTk=";
    };
    gpu = {
      cu126 = {
        cp312 = "sha256-rYlNNuvnK3j3th+HltQPlyeLowA648E4qkUW2a8GBOU=";
        cp313 = "sha256-hb1kDryNy72pjtNaj7SJIfL3hMsx9xMIbJ67hy2JDEU=";
      };
      cu129 = {
        cp312 = "sha256-Ukci896/PoTmk6Za1ZzZnO5NDeN7xMgfUMJK4Jj57J0=";
        cp313 = "sha256-pkNs7L3AEqGARs4iM7n5eReMHj+ZJj8LGHefXmmQNTM=";
      };
      cu130 = {
        cp312 = "sha256-yD4wdgkwRm1FdvyGAPExwpomCc4M/PC2RugBpsCUWZ8=";
        cp313 = "sha256-3zmZ4mbxhC8LL/+wT9ip43F8E0iwzHjP9tm8+hYcTBE=";
      };
    };
  };
  aarch64-linux = {
    platform = "linux_aarch64";
    cpu = {
      cp312 = "sha256-1GeE+enBxjIc9BTulCvXBeC6HI0XRcPdf/20mb/HE3w=";
      cp313 = "sha256-LfBVU8RHRDXAAFlfN623fOUJMWGFT5AWntKTyDaLlB4=";
    };
  };
  aarch64-darwin = {
    platform = "macosx_11_0_arm64";
    cpu = {
      cp312 = "sha256-F6q2uQ2M7yzPiT9L6CzwXpBuIf6GxAo0/qZwGTfXeCs=";
      cp313 = "sha256-tWeBNUsYBj9DqH89ViraWk+KQ3/iMSqxAy+omtWlTsA=";
    };
  };
}
