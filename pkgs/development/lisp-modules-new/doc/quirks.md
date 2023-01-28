## Quirks

- `+` in names are converted to `_plus{_,}`: `cl+ssl`->`cl_plus_ssl`, `alexandria+`->`alexandria_plus`
- `.` to `_dot_`: `iolib.base`->`iolib_dot_base`
- names starting with a number have a `_` prepended (`3d-vectors`->`_3d-vectors`)
