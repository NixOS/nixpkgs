import importlib
import pkgutil

import _sage_conf

config = {}
pkg_config_paths = []

for info in sorted(
    pkgutil.iter_modules(_sage_conf.__path__),
    key=lambda item: item.name,
):
    if not info.name.startswith("passagemath_runtime_"):
        continue

    module = importlib.import_module(f"_sage_conf.{info.name}")

    for key, value in vars(module).items():
        if not key.isupper():
            continue

        # Values of the different PKG_CONFIG_PATHS are merged
        if key == "PKG_CONFIG_PATHS":
            pkg_config_paths.extend(value)
        elif key in config:
            raise ValueError(f"Duplicate Sage configuration: {key}")
        else:
            config[key] = value

config["PKG_CONFIG_PATHS"] = list(dict.fromkeys(pkg_config_paths))

globals().update(config)
