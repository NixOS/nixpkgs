{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (eol)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.23";
      hash = "sha512-tTUJLRivsRqJGITvyAYp732ZU5byuuaFOx4dbfl8sOpIkCvUckkpjL+occOQmeTVOMo0PIjE18biHqDdewwETg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.23";
      hash = "sha512-LSkSujSX9xnv3dMFFFoYFnLXjp0aWCXAhLvaemN6cwk9VopEWUYqaRed+KqgWsHPfEEaWnfp8vVR15YFhGa5Bw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.23";
      hash = "sha512-+Ry23+CwUQr6X/qIST4CXk5gqyvHInI/MSX1oqWAF0cwHcxiZN8uJqBYwgD3JytVDw4ToAqkV4G3FwXTe55YwA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.23";
      hash = "sha512-whVcze11KACJ5ir8fYyYUpAXDe6iSQSw8PmPqsdS7DD0thHPvjkdChgoMy0yTyyc8zxL+O6hKFG5UkDI5Da7WQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.23";
      hash = "sha512-qcTPCARQGfMZzEHzHVH5Ry8MtOmd8y0p0Yo3eRGoVaL11HW5Sxv/MAkv7jMSyzNr2FipPEkEm0Zdc+LmBAXkIg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.23";
        hash = "sha512-VwId0yF/KZ2i+zTc7Q7fKTdopF2fyR+k1UrOf688Y0g4O0a4cCdvHTBvfRDiuRGdzZjFGqEHGsfsSQAJNyJBxQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.23";
        hash = "sha512-EPCAZCvu+N0kVg6dM67aACG713loIKcxO4BqmYTh5HnQnqSa4eVeOpsGqwXo1hKZcw8/vHzq03F9LJMn6KEdQw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-Vl8RDEYt5QOwmB9+A7Rr4VzIqelxxtr1IH0y/T+qnkvt1vFdMbYnEi3jkaxVqdfd4e25QGgw0uTii52AwzByDQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.23";
        hash = "sha512-NnoIwr4VqhbX7EhV8bmVtGr7+qvIkwQpHnzghnSLAfW7t5eVYAvbyU/7BnO+ZkgOi1W9FHQ69nkJ2zbk8YuIQg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-bSIj++HoUDTKxfvgOEuDkRKHGYtKD3W6EJvCK5T9oz4S97gs58IfqkNf0GZ1GfhSU+5YSF9YjoYRu4k/Tdm/Jw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.23";
        hash = "sha512-oft6MUHOyDjUQjM/OGOTwGWOKFAhmOTAOiXuItOYb600sdLyPLGbV26ERG90xUq+dJCjB1j1lGFCuyPQ4qXRCQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.23";
        hash = "sha512-yTnHXNytQwUXRfmmaRud2bN/HTvOh2Q5+MQn9NV1MHqbxEsaBckTa0GXegQh/k3Hf4Q7OLkwx3jABi+kj5LbqA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-GjMNdlSLfnhNKrrqihoi+ArEcwEQkvY43wFIid488ATDZ0t175qR3jTylWKv2z0BJxdIi9Zo1M0S0PR0Bb5VRA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.23";
        hash = "sha512-uogUyJCi9MYNCspv36nYkgJ8mmka2EvEMYOBr527UsWVG4u3LDuv/5U9WM9oIM1ZzcDfx5hwcHV2ssd1oY0DTA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-SaYNpM091jAMzVqQLTWIBQwWEwwcC8610gWJOQihd89/QF8HawLnam0Y6ezdpQCcKP17q0Bfr4i1nqzPxjuYzw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.23";
        hash = "sha512-AymVWEeRbFOHNXwi9HFBr0ovMErB7xb5s6NLUiFKgPofMCRUhAvhV+VVk5XLJoT9YdhyjkIhCKtjHV0seypAxA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-VSGdBOYtS4gBcxJULaxyzNj97u8gqhGEIDg/DC7JKBCmaOTPf9tTIdd1EEzz9Bi2nZ6ejV8Pbyf5qmbQdrMOEw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.23";
        hash = "sha512-6PcyIdLP3qIi7G+HXXgLHtUj4d8Zb+SfEAt5QYC5yEkmlCQ2nVPnom7XMHWv2YJRdNPGBOuHGhjVC1BsXhi2Tw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-MK2MbF9c1JgiuUzycyFY+95iA257XiVgbBaQaHXTx7j+ATMMJpvpoP8SfbXdMawkkoS7yrpFZg4u3TXgaanDBg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.23";
        hash = "sha512-qGcwNq3uuXZAUhmZBcR+QxvlgcV2InK1UKaqwXudIu4+ltHriXUdF9MmUXt4IoMxHoXBhXvY1OgeUu8NlNrLlw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-9LZ0CLJ9FOBjLQJ46ZIbZmOeBFDbFPHGCNjYfwcUbKfFSsj4k/9IgvQyQHd/w4L1Fw4Q0atCiF3zUxUs5nAwmA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.23";
        hash = "sha512-3tTEx1xyZGrbj3co7TBRrvCr5lXy5cShH1yjdqlhUglF9PtC0Bkc5dVATu9QeN8vX26yIIqgXRue+JN89kUh+g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.23";
        hash = "sha512-C6s8AUgwqV/ybpcnH5kGLOqb4p+LasRC3kEEkh6UpkdBm1ZvkfsocqSDkh0JXmnG6VlJUmtfey2hX9fpJm5/lg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.23";
        hash = "sha512-ucvfDShU86cqHW1EmH8U8LDaVqVSFAYmFxbcGuBQHmcEIk1KT3Y7CpjPZUkzgkV1vUq9QXxsq7dTKiAGQk5sHg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.23";
        hash = "sha512-W/jajKZ9MijQZwK5ps6ucSH6KNFy6pCoL6LGryanFnsgz6a5khcT+hWWUzYLZVOMKNB29nJKt4RCVyNYw8Q4dw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.23";
        hash = "sha512-c3jSEjpGkYjj7HdaX79CD5UzfT/0N73A9ThcpgVcW1TNPa1Ju+VJ3jWY+6cQYBxcCicHC32U1pxIFhJ3D6YwXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.23";
        hash = "sha512-mhlVBq/o6QKANyD8t5CDaq4tzYQR4UmzjuHes0cnfo4s0qjh7DGNitsY37Qc2m+bpUtl6msp8zqsYqOg7FMe8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-1CSrGOfrcaEAgl2kWFjvxAAxCZf+QRwdPQJPK2bsqxk0p1KEYQDar/012BUx7dP4x4pMjMqB8EQX9d+OaDKnLg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.23";
        hash = "sha512-vMKLgrXe1B4gxdeKkaR6uI7S1gTVfQbNMlAS4oquGfuzJ8jcbMp/mV6thpDvq3FcreMOVP2DYYgq1Ob1BmIpEA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.23";
        hash = "sha512-bSDoS/I3TtLATaVPTGU1g0V2pUHwvNArXth/RW5LWkW8t66CbWsaBXOLDp5QN0l1uv0Y6AD03Lo5fM0DwdooZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.23";
        hash = "sha512-dW0TeTPROzXrEolQBIXwITM7vL47xu11bv/1bMun30rcvMnXdllbHEAxphwD9yFOH7IZHDHM7KEOPx7KChUWcg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-9eA025KnaOJ3YwtDllZoJ8ARXWdD43R5OTQVe/18HO8Jfk9haDIe/tNYOrZYnaKhOjdEjueO2mBZBmGNRTSrvw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.23";
        hash = "sha512-bizRsMfOh78icM3rED5FWtaGjSIfu9LAEys4j7nnX6N3HIlew0Iwhs2MPZSwNSk7cZ/Q6zqcJwuRJCDANI7rMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.23";
        hash = "sha512-5401zjNq7VzTp2aha3id+7dLVCjtKlM+J2PPBkelpHtht3ojKoHqpePfwLFAntD14WNm3O8UavpfoT7CsZnFyA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.23";
        hash = "sha512-vXCR5xzrQoJY3+QmjyM/B3w5qJFGQ2DfYZGJ1whveKUCOp1/s9fplAy/9SIEY2TbFz/tctpkSssLzu+NQBEv+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-So54fzVUqeMmPYKnJBhGHH68wRg6FBIjwcgizGesblp7nPZ2xEGN2z+pgrDGrkwu+NLT7u9fnp/XGum3KVqrRg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.23";
        hash = "sha512-t4Bb/GLBD3UQU+nBCCbTGse5tNH5cWNh9f1yDYk9Xk29REqroaBj4nSGXIWjeB17PFEOedP/ktmaBz4Hh7YqMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.23";
        hash = "sha512-Q1eMDfrB1HSf33bVcNCzb2WFqyHG9u+bixM29w+BsZwvnzC7F2xFG2ocKN8b1lPcaIelsIvxGhvz9azlMdkRYg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.23";
        hash = "sha512-+vh3rfRs+CN0/NWw0z3KOLuWyB2koWsYITRSdfv65NQHeTQk97vYpLNtxwhf9upNbza3MpE94KDaJwN63V6Qmg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-+Q0n0nH56lDyBEsaBNu8ZGcE0zj/6S0yaXsCqrntKROC2SgzZVR5YnmfVXTJLZ0H4hHoCNKY4vgLMp2xxSJo3Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.23";
        hash = "sha512-toA8KwWSJ7libQ21vvKBgZJBjNAaoa0naYqZ1e8qmbXVOsGgFVGslZknsLOqkNDdwZT5dCdQ7UjCDiDEORSPPQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.23";
        hash = "sha512-CVkzOMOmgVd1/MojYPQzzFZ07Glvb14VjTMHjCTaK0c+a8q2f2vgLiLN8toHtCtg42fM/lGoKZmbI02RRVv8wg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.23";
        hash = "sha512-AyV3Y8RxIuUEITbgBumwx0LAakxbHFGK/sBCFeQtk8hhqv+WqDAi5DlXru9gEfO4I3H0MvX7XtDg4d5BjkVNxg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-KTsJ6JwHXf+r2BTbtKCSUfamK4ePlR8xDQhG2YCxPVuIfkEBPOLlLtL2z4EC+KlFBwafEWeukx5su4Z7tteOcQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.23";
        hash = "sha512-RtHsJ7BIEXtnYJXKAJu6sz0KmmH8kGyJMhRO7KrARjkrvjyw3NBEVyEHv1wk1GAZ6HtqCSLjuD/eSEsOvJaCqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.23";
        hash = "sha512-GN7WKN+5NzGo6LmHI1hcIo3G9QMlHl0m+kIWDOG8mKHnm1nwimlasJ7K7zsRztv3O331JjI0yuiascOeUbg7/A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.23";
        hash = "sha512-QB5RUNtLlUrZZW6DJgSCI+YwxqXFEbo8f087SGn5XUl+hw/a8uF/D6zE0yTICls3STA36PlPakGndh2BvMZkxA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-cxqUOwLS9Ey3F68FQCs387ioLzVuZq9WPkw7bRPcRudEk/Tk0Zm0o87rEVOh1so0QqfzvPi6h6X3/hb5ds3xxg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.23";
        hash = "sha512-ERzeC3nOohe6XP1Eaaw9G+NUL9mxlORjYhlWRaYcVSVjfybednl5Qo6KwDn/mwq3YN+s0dc2Ay7Bfsr3l+QDUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.23";
        hash = "sha512-RNBmcbeTBlsMd+gUOlPbzN/3p7Nq5PqK2/sFV7pO/GIROcAwvqT6RQCsFVhp3LWXGeE6v+1xS0KoIcric/fenA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.23";
        hash = "sha512-IT436b5Pwhm/FndHGYxA3BUbwiiZvIla7bnKHIezB9iTPSfC0s7bfwl8xDZYqzFFBrB59uVBLKmqFq4spVUeqw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-5KXzEl3NrM5NMBxCuzgmx7/n9u8CdGlQPhnyQUnslw5OnALBvAYO9Bil/Q3HL9CSgBw5o7QvB4A0QD+AsHb5OQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.23";
        hash = "sha512-4vSGv0EyJGMS0s2N9kA/iowsTlzC4md+Qja3UbiOMxtX6gyHmPEU6ewEIutocz4RMmLEQ1SaelBgpFvVY4hjpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.23";
        hash = "sha512-+Q5wU7ZN/M73gGKsvtwpor+dbkcxJOM/n3NFYgXbjdLoA3RZActTpSS2tdZzizMx+9CiXS/gfOfelsINRuas1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.23";
        hash = "sha512-RQUQJjMBiWNv2EX3aZqduBgSZZCdZGxQqhJ1SBna2HoUekEBOsyGJWE0VN+tsAfu1fd7gokvJGI7DaCf3NDnyw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-3lFfUB6CBHsi6ETE140UgXVzqZYGgpL1acsinFwSUTHVlTrBfe8GiuWFRKZoDpjz79RqIhNmerMQNGq1D1V/iQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.23";
        hash = "sha512-0hC9+JBYnnZLehqjiWpoeN42hql3P6Pu+WE6Bmk/i0Q2rWJo1qJwMYSo0BJ82dVcRjjAftgGNoJ+u6rcDxjiTQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.23";
        hash = "sha512-hxhwmsuRBzX8V7ttcNa/v1kKEbTV5NRJdie8vmpa7wTL83YTSHpRDx+cbvTTkV9fMyTui3pYMmsCHrYjhPsrKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.23";
        hash = "sha512-oQ9KrVH6A+dOgJ/4xxjQjGv5yLAPehLtENPNQsnLx5E1MWluzj5oIdxnYN6i/BgcF0sVzAuAyz1aL3WDgV4Rtg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-PS3yAN7+8uyinA4tTOQmAoOxtzNJ/HWVuvC36OcQ/gjal055NmUdVelP7MPrsChq9OJ00dTpEDW7DuM6DMQNzQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.23";
        hash = "sha512-iDgIB1sPfzi9p+LRIY664EP4hH3f+4XtcJjVnXOVJHzsAG8LYMu3lUsLcYtRyhc+ExN6j6qNnFdCm0jICuo5Gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.23";
        hash = "sha512-v4V/Bnqahcar4q3WPmfPpr+rReBkcfAo3Wp7zRcnEvjohBxtxZ8tdTcBN5welrMMTvQabFlg6CRqjYUeWa5ueQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.23";
        hash = "sha512-2mfCezJAHfAuI8Hf7li9+1BiU6NEAIw7H6egACkQbkc41DGTSqB9VP2vjy9oZhTB6s/t+FQVC/hWMCPnQz6R8Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-GnaSw7DwRNnqujTF06X158geDd5C+ycugZz7BHOcX6k08ye+/c7bq6SeDXGP2pIPwvkG1L5BnrZ/Gouj1qaqtA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.23";
        hash = "sha512-L4FyRg91XTQGlJwXmsqXEli2J08lGZgr1A94ZuMkViOH4w3+rOqvvE+y7JaTc4yknvhl7vvk7YfAob/uE9yZAw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.23";
        hash = "sha512-T/cOOSyq3ETagNT54VrL7KHNFepMncE5KdLjx/MOmJeSVf2ubmQFz7OW4advgLp+Tt7zz9FJdcoANihafNplwQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.23";
        hash = "sha512-7Y8gACmwQt/r0WpUOmc5gkbFpug1AesGr64rSHU2EZ4qCkwpRf3wNFwwwz7ZNLb7KsC/JMjoPU8vl0nQe0qa0w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.23";
        hash = "sha512-geKEdIaz9xekWCax8RgjwI9DHp9UuQ6CuvWFzl7YwJn/mbfVQS+6VkF4yq6L5ShKqUyIOX9L7586PuQPBDzSFw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.23";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.23";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-linux-arm.tar.gz";
        hash = "sha512-4QmLiZv4lU1+yUbxEoxjrvOZydhxQjL/VzbKI6VurKMfUFTwN/C3QQusFnQxYD+phhC7BH5RIHIGYWb6nPdVjg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-linux-arm64.tar.gz";
        hash = "sha512-7aDWpcWAGfgyhPQossDRXHaJ+xQcRS9Y8wrcsENm6+SZpZlgAMbNH3tJeZiejiZx7dysCpDYYyOmKEjdbGgbCw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-linux-x64.tar.gz";
        hash = "sha512-1PXS48cpbDc2gX29ObSUKoqKshNwMoVjifUz6TyUJ1sR4ga1gPPS4n36Lav5al7H6526kSD5ehKF5t9UOHSyGw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-linux-musl-arm.tar.gz";
        hash = "sha512-juEwCN94yrJ/FZOibUiM8DlOdNpwLULTwz0QbrL9jM0Ahopk93fDETdTxK/vhztb9AeHgp0rm/6RGU72TORMKg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-linux-musl-arm64.tar.gz";
        hash = "sha512-vv7YsSf6FApAErYSJLOqd0wFG8m31gdw2aFeLqWszxmuL/HqtireqjoNToKUPm/PAqvRzqL8RCrLh9PFpvApkg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-linux-musl-x64.tar.gz";
        hash = "sha512-ZR1dnxiomJ2qnZn2i2HVievZR1vq+Gl0VJfkAkJ+8U/Gk9ZIb8WVHFtkvSGLclegAbnEbq5sANcr+mxrG3PwQA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-osx-arm64.tar.gz";
        hash = "sha512-Zl60+a7lkpjw8ihS2HjMOv4oub31wD/T+v3nzeZUpV0MPgJi/RK1jh0E1upRTosjIZCVcEB+Rl9H3gd+hPCa/Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.23/aspnetcore-runtime-9.0.23-osx-x64.tar.gz";
        hash = "sha512-L5+WAOW+6scdYQGpoMII9dlkMW3jLk0VNmvGE8mF1VjwtOESHDxLO7w242N8/zVG3JfIG/ANxAy54Cyj87mDyg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.23";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-linux-arm.tar.gz";
        hash = "sha512-on/woD/L19o2ML63GH/yr4VtLh6HDU+j3NTFBOWGkRNS7AO0RlsurzxibkWIRUlxUSLlLqTNFwMoeBpvkgwNSw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-linux-arm64.tar.gz";
        hash = "sha512-BgbiEuRqf+TSpKEc21LyvkoY5o0r1WSnJKvsxiSos0e20M6Xa5T2C3hjJ3/udLQW2J6MSlC3TjrdsyTuNkifyQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-linux-x64.tar.gz";
        hash = "sha512-aoCJWp9D02/5XueRA7YAbYA9Kq6dgsbfFJYuatLn+IQ78xuUQLqp1Eo9kxuAVpjTlE+KVXPawvM+M5pVzyzTcA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-linux-musl-arm.tar.gz";
        hash = "sha512-BOtuthpzkwe/9jF8AZS7RlmJSc3nezs9oKC0atsdUWb/9cJoPvteVDaR5pwjJwqnfIp+rajcneIBscOYI3I9bg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-linux-musl-arm64.tar.gz";
        hash = "sha512-aw2PoWJhIAhgBt2qSJc8Wo1DEsDdd9dErCRpfAYmrnBkrkbi5NPTLrRcVqfN9fIvtmZT1rStK6myNljjzi7wtw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-linux-musl-x64.tar.gz";
        hash = "sha512-JQghKloBkaNstENds8t5Dxnm2UCHGVnzMBoX+Je05LMVz98rRTaxZeHEfohibCivAzbkF72whM4ZKDUF2v9Tlg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-osx-arm64.tar.gz";
        hash = "sha512-nBzAMIMDRg74R0wOfKGbc34tNOWJivP/apwIRv/zuOsvHNy5y2/UZzfcOYAMC4fA1uJyqa+ukGi0iAifuj/3Hg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.23/dotnet-runtime-9.0.23-osx-x64.tar.gz";
        hash = "sha512-EpyqOje/d+DlAsRmKbILqJwyBnmfguo1LyvrCzImEMzO2Ak8BbnvCZ2vZeW8jKRwFmNGJRYyGGXeaDLmYcIehw==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.321";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-linux-arm.tar.gz";
        hash = "sha512-EZW0dRtxEiSdF00LUCa6TqaMahGB16wLRhHjuozK+I9fXoio9feTW5jZQFlvhwm+EqiGTSgWswo+TZxrrpAbWQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-linux-arm64.tar.gz";
        hash = "sha512-W0fl+FxYQdHRiaJk4TOGDXQwf0hTcjKgOsO9OdK6QUE6h78n16dFeeF110VpMsCEFxgQPWnh689lOc9GPA8U7w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-linux-x64.tar.gz";
        hash = "sha512-YSuujpC+bmm2W5BGR7iKKNDYxNee1LII2f36Yas0vlfm/QGKtGw4l9wIqtIDOAEw5q8+dI90KgmqEfjxicq36A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-linux-musl-arm.tar.gz";
        hash = "sha512-scq6kGv6eDFMV/SH5Bpxi/HO9c93uVbpSa/CTaAjp5DxBcx5heqSFKNWOmcGnHoF5/8fUolHtXJ12f0i/oOVww==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-linux-musl-arm64.tar.gz";
        hash = "sha512-1Jd0bq2btHT5wRrVUoo1yMRNge2b0rwCY8PXCX5Z4LCoKOmk+pSBm5Yg5b8FWhhalCXVKQgIPT15EcSRFXPC9Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-linux-musl-x64.tar.gz";
        hash = "sha512-j0gmx+FkjEoWtldmC2rpmfopzPOmwtWM8nSDjGwHMh71st35s4pVsty+GevUG3wExS2KyPbKHvDODw05dHbhYQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-osx-arm64.tar.gz";
        hash = "sha512-K0//Wocs4hT/vhwAG4iauRo3yMVJWa2zfX8g9sssTDAxbjkmvPu5XlbNxUGrA5PsxVufBwCyTyQwVswYbzgIEg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.321/dotnet-sdk-9.0.321-osx-x64.tar.gz";
        hash = "sha512-dCRqIkO6l1qYrhmpXehrmjHmVNfW38K+dGTs8RUdO90vySWt1OHjW9yCmsr/lSkSwsqBMnXjxSyfATu1dbheWg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.124";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-linux-arm.tar.gz";
        hash = "sha512-2Q0G0FtvqdAU+dhFSG4wQnAywQEmSF05gQkK8AXj1Kyci3NGUUgTnp97i3La9eQmKeK6sCPva8EQ+Xzg4mfEUQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-linux-arm64.tar.gz";
        hash = "sha512-FQxacBNQVqBMxRBqNYJrfVhhTa3FIILMMD+1LNRWNUDI28DuMP7RRoggHYZI/sXt+qCZcvVAKC1UI3z7+O24eQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-linux-x64.tar.gz";
        hash = "sha512-czmkQIDjuZr9Rh+FSGC9NsJszsVVmYPDhSbkfqQIei07EEVGx8DxkVxxzoq7+22R2tEzC+L1Qn3y3kGvLdeJFQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-linux-musl-arm.tar.gz";
        hash = "sha512-0dSo0Qx/dSNvoS2XE83vXE0GHdiQ1H7uwE7XVLfDR0WJak8ByqRY6GP0eKPOiVN3n6eJk4L0xqKicDQ6iuBEAg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-linux-musl-arm64.tar.gz";
        hash = "sha512-2BF5LLJuRtMa3omqcXVrnlBvhGSTRF3s9E7T6TCa1DhfpRA+eyN8blbEiRIoPV+xVZCmkcF4igEyR/9BzUZmbA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-linux-musl-x64.tar.gz";
        hash = "sha512-MyeTZPYFav4MJMJrdI7HOfZoRC+yQQvdc4BNtlc5mw2iWtrRDY1MQQ2bSeIV98y0gn8vAwZHTSFg21434Yh6lA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-osx-arm64.tar.gz";
        hash = "sha512-YRSmN2MxBod87T689tsGOjILE+zDzKZC/KLuCmQITzBf3WytazxT6nYR0alTFiBrIeh+g/vAwnIpZEBfChV9Tw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.124/dotnet-sdk-9.0.124-osx-x64.tar.gz";
        hash = "sha512-d5k4H59PSAfZIRvOZyGIRltm2VtYO6WpI3YQ3DD9mjvHwhG6HMOZy5B8t98s27P5HOJY8E2NWkUXkUa/4jK+PQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
