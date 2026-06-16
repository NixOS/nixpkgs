{
  truecrack,
  ...
}@args:

truecrack.override (
  {
    cudaSupport = true;
  }
  // removeAttrs args [ "truecrack" ]
)
