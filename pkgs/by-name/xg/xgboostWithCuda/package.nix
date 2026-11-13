{
  xgboost,
  ...
}@args:

xgboost.override (
  {
    cudaSupport = true;
  }
  // removeAttrs args [ "xgboost" ]
)
