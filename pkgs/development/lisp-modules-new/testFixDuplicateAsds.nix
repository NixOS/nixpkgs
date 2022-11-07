# nix repl script

:l .
libs = [ sbclPackages.xpath_slash_test ]
libsFlat = flattenedDeps libs
asdCounts = frequencies (concatMap (getAttr "asds") libsFlat)
libsFlat
asdCounts
duplicates = attrNames (filterAttrs (n: v: v > 1) asdCounts)
duplicates
asd = "xpath"
providers = filter (lib: elem asd lib.asds) libsFlat
providers
lispLibs = unique (concatMap (lib: lib.lispLibs) providers)
lispLibs
systems = unique (concatMap (lib: lib.systems) providers)
systems
makeAttrName asd
master = sbclPackages.xpath
master
circular = filter (lib: elem asd (concatMap (getAttr "asds") lib.lispLibs)) (flattenedDeps lispLibs)
circular
circularAsds = concatMap (getAttr "asds") circular
circularSystems = concatMap (getAttr "systems") circular
circularLibs = concatMap (getAttr "lispLibs") circular
circularAsds
circularSystems
circularLibs
lispLibs
systems
master
libsFlat
providers
lispLibs
systems
circular
circular = filter (lib: elem asd (concatMap (getAttr "asds") lib.lispLibs)) [master] ++ (flattenedDeps lispLibs)
circular
circular = filter (lib: elem asd (concatMap (getAttr "asds") lib.lispLibs)) (flattenedDeps lispLibs)
circular
