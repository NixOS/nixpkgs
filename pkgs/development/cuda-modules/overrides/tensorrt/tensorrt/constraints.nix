{
  # Releases for x86_64 can use any CUDA version so long as the major version matches the
  # cuda variant of the package.
  # Other platforms must use the CUDA version specified here.
  "10.0.1.6" = {
    linux-aarch64 = {
      cudaVersion = "12.4";
      cudnnVersion = "8.9.6";
    };
    linux-sbsa = {
      cudaVersion = "12.4";
      cudnnVersion = "8.9.7";
    };
    linux-x86_64.cudnnVersion = "8.9.7";
  };
}
