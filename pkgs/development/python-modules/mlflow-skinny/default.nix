{
  buildPythonPackage,
  mlflow,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlflow-skinny";
  inherit (mlflow)
    version
    pyproject
    src
    build-system
    pythonRelaxDeps
    dependencies
    pythonImportsCheck
    doCheck
    ;

  sourceRoot = "${finalAttrs.src.name}/libs/skinny";

  meta = mlflow.meta // {
    description = "Lightweight version of MLflow that is designed to minimize package size";
    homepage = "https://github.com/mlflow/mlflow/tree/master/libs/skinny";
  };
})
