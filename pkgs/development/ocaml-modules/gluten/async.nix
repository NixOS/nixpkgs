{
  buildDunePackage,
  gluten,
  async,
  faraday-async,
  core,
}:

buildDunePackage {
  pname = "gluten-async";
  inherit (gluten) src version;

  propagatedBuildInputs = [
    gluten
    async
    faraday-async
    core
  ];

  meta = gluten.meta // {
    description = "Async support for gluten";
  };
}
