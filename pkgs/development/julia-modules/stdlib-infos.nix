{
  julia,
  runCommand,
}:

let
  juliaExpression = ''
    using Pkg
    open(ENV["out"], "w") do io
        println(io, "stdlib_root: \"$(Sys.STDLIB)\"")

        println(io, "julia_version: \"$(string(VERSION))\"")

        stdlibs = Pkg.Types.stdlibs()
        println(io, "stdlibs:")
        for (uuid, (name, version)) in stdlibs
            println(io, "  \"$(uuid)\": ")
            println(io, "    name: $name")
            println(io, "    version: $version")
        end
    end
  '';
in

runCommand "julia-stdlib-infos.yml"
  {
    buildInputs = [
      julia
    ];
  }
  ''
    # Prevent a warning where Julia tries to download package server info
    export JULIA_PKG_SERVER=""

    julia -e '${juliaExpression}';
  ''
