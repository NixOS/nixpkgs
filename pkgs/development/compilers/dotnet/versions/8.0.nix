{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.22";
      hash = "sha512-ba3CvondlctoGshrN0AwqJ/Y9knc1gQ21VK5Drp/w+M6rw9pxT81g+kcKLxj4mxNeFuF32cGevycVLILkDyY8Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.22";
      hash = "sha512-amPnvUlo/sFZxRJ4yNWBIJXLpPdOscALcs55/XtgmDcMWhwHslIihaFbuxyqmmFJeCyk6lgSPjCBD6hbq9VUVQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.22";
      hash = "sha512-U8PXXYlTvuoQckHUdgOhxqVnVZBJxFr8WXhpRn6AIQQw1qN+6pVFPTnUSNbhfvi7TBBsWFA/Meaf4nP9576rXg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.22";
      hash = "sha512-bmbrpLhTfQs0YVmzFY0aMnYNdyrzEA0OJYDnqnb92+Tss0AV3ywvZZLU/9P/K4vOtNFu/UxwDw+D7Si2sZbPhA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.22";
      hash = "sha512-0bXRC8ugV7aWkEXwini0gaw/kBh63cONGdwDAUilbymjVpiiBsAKnFnnOklHAQEMOQ8KE+JNejGZrRyCGFA1EA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.22";
      hash = "sha512-TQRUQ8nD0Ou/PieUjdew0aQXAUZPUyX6XDkmKKqGakGlQQKjPvgWLLHAFTxXrNQOx5JENQWOsDucAEkz74NMqg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.22";
      hash = "sha512-3OLufdLWWZZnoxAwAb2oLHeLiY5PMC2VGR4hyRbt9SksFRQxhxCT6tqtAFMVcRVXrJOxdkojbNVzcRh3iFPVzQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.22";
      hash = "sha512-iYmOLnweVM6lBYOPad9V+6jshSD3SW+OTebTEo3o3sFuvQMjxyj8c9JfjUStrWbZJZoqqMwt8y23ePFdImtahg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.22";
        hash = "sha512-IeEx0GdDoz4TbocbHssnxax/Fiqm5zm7nk0rJ2dvEtAapC4CmnYLPwBNRD2KMo/iQvf6IF8TDsv3S6LkKb+JWA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.22";
        hash = "sha512-uvrxZdnGkTnQg/ZPhZ8IzvaOE8LC7npFutwrBoIJ4yeMDoomCFbVXkDbN8CRpHbSgABS5OwKcvrYQM6V7NZ5fw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-RR2Cqc44GcwrsTMzngujcO8qZxTkaG5RGRbn8EKy67X/MUa8+wUjdRQv6ddnkxJ2PQdX/aYdkx0dpO/HOp7+Pw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.22";
        hash = "sha512-izDMpYJr528yWoj9UwXJlRY7SA8wDkibuhtq6t3oOHLE3DrzJB8UDtpYx+f0Ampal9amYG2sOgMSHvqA1Xed9g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-Sx/I8iody93kYKFa+ffzLfgfqWeXuQrRoFGV3kh8tHIHWzxlH3EOxOvH4pj3qLkuhBJ9ErQpd0m8UrkIqQ3a2g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.22";
        hash = "sha512-TBVXvf6zENHJlFW/kHtyXpV4sxMbyDFLmJQb2sMh+V4F5C2tCCu3+R2MOniNf95JBzjqG17S373eeUIWsMxyoQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.22";
        hash = "sha512-bISxZCAKRYHUHdYa9/9gR6RyrbUVv5YUBfqgJ2hYWIf1rFEB3vkYZWe9ysqG7EHA19n59nWmU9jDW+NOC6BSgw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-xOjn62Y5FlWY34mLcZR5gRp4hfGu5wj/9PT+HT+CZQ6EcJ+xqhb5hiygJSjsCwqDnQCKvcr9hXElhPyUFvRWQA==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.22";
        hash = "sha512-hLgDPOcc7MMK/PkQLnZzcAAuGPWpsoWdsE6IJwQXKqYH5ZNRikgmMLOE7an/aVhH1LeFXFC+JD94/xU/PDeP5Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-yMAnYrJaBAwcv/gjOcEw5aW/FF7i83jf8DskHx/gtAR/zPwRo/f//dL13iyFKR7w04v7ZNXWDnz4G1dC9UTp4w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.22";
        hash = "sha512-pWvjShXugv3pUpqFaV9l2ibzGa0w97Br3xfxjqOugSQJMF5JTbGWY4OqNG7i1dsAjuGAZquqvLiC4gEGyxXFog==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-pH8lL82nUL0YkWWznRfrKsalkrC63Oc1pTTfHWTp1UQg17HrtF5l0rLqi693h8aSH0H+/PXShfL2ZIdQKtkmRw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.22";
        hash = "sha512-8x9Vf7jhCEDN/PNGahlKVYp1g4J9UDsLfLu7BgUhEKhtnaVB8i0pc6hDGIYPeEz79sp2tZYcNw/ZVNOaY/wufg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-UOk19HsHzOH0vKwEeFOultu0RYOC2Opm2VtbQ3hBNrn1nAdObrn3FoGL1eoNIOB6q2o/XKU0SMxSFRe5Cbt7Lg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.22";
        hash = "sha512-MuTyYcebLzfUcjTScTA+oCBOWn/9f4Lf3fhr4FpKkPKEKIkdsm1W0s20JI8aUQi0wUb1H8Zy1J/apjkFIjOATQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-NPKm0qkNvEAz/j04/KbdIx5Zye1Bbv9XnZKZYf4jDzC+q8oEDU/O9KF6Z9ifamEqarfb8k0cAxGixWKpwyefRA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.22";
        hash = "sha512-QX2xQz6U5PlQstXQq5PHfgNioQc0Rmgz5chafo4qUxBZgQnzrwBadsa7fFy6X0wrl2J3c0U1+uunGsEtgYf5bw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.22";
        hash = "sha512-dQxv1r11Ke0xWLwIFe1CglmMEqmnhLxUfGm4aNKoYWFhut85ySaUjjLNxcQ2LhC5rwDTM/PxPqlXS7FUlHZnvA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.22";
        hash = "sha512-KDFqk3CqQTe01JauyBpwZY/FbqNJUXru30rN6kGpu4P2+WYBJ9oDNeiJeLduzF5+N0zb6PLrdamjK7y673OfQw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.22";
        hash = "sha512-asWhEGiIMIFAMQ5PNL89nK9Gr5kxIqPA6xjqeejX2ldSrr/Q1vOQ4CbDy+fVXsu84Mrfgc1OUtuw5Yn4ERKEQQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.22";
        hash = "sha512-q9HaFnp++URcCpGRHxjgMStbUqHbO+WndJISEufVFBMhgu0xGxo5tIN9LvEcNPuXUVDUx/XMHcui18jQ4cyTng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.22";
        hash = "sha512-nakz7RobueJ4292wUseem8epXva8oYkY/QCOAdQYawo54RTZooOoP93Kp1ZBqa+KPMfr7nx4vjibfQQCeYBHNQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-ttWAZwH4qd9lIoB+5t4rvMK3dlHvYiARxd7MsCPBfPZlo4IL1M4f2K6/fhIbJMQOmXsx8pNMwv92IdAfwDJCuQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-Edw+gAsRoc8lVnRBVwaCw87VpzYQcAXMUPJ6AUAT9Lsj6PGDaQADeDIUHglrQOGYgFwd72V2+DAZEC6bvpi8dA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-9pMZHcNIBKDOVdStuwMTPcO2zMaw7AzNwS3M68zrouZeYD5I6jvaLYHcEXDnE52iD5gv6gi5cre4LCE6LkoWnA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-ZP88yN3xhwrYMK+Lk74JUiLor6C7oem6eVaKhDaUAz5zRKJzMYc08O05Rpz0ak1+I7ua+dOJ2lC9POK0UPBCTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.22";
        hash = "sha512-+dkTm0+cyQIZR+p7CEemrosswDqfMmvrN1kuljXkhCwqKKW+rjRhJ7ApFuYsFM1SSiERl2eCpdwt8coEJWwm7w==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.22";
        hash = "sha512-CTF5PhMx7VYISqTKYU3FMZMi+d70p0TRHh5vYuMRZi0piWZjxxH4f9ZyFb1u/URrW4V64/Rjjepj/S4jEW30iQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.22";
        hash = "sha512-7kxDN1WM5P8d6xGtEzjSc1vXd8jad4hA4iU91PdbuxahfqhyBJiIiwGRwCffd3xD3xcsNcga/2r2jdZ3oOxaCg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.22";
        hash = "sha512-3C0aZfdT/RJp9H/HdyGrS84GOGoE/fcJG48vw8gjMxozTaGxDo1voL9sV5+OO+RSjo4gWvPftzEwkL3i2oLdZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-s9UEuwnL+O+1QqVPcjejlIwX0JaXOsfG1dpGnE0jvnA6Hm/CSeih8t4iNg41BDhO3yIFFGwhvUYmcrLMrSeTbg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-LXvUcLSaWsnauTUuEw3dVDRxi92Gpt5TCfkMk/FsB1KP/LYlqvogsPhGOF0UwYvnlem3B8CKa4Es44JnHW6y9w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-kjuN9j4B/+Uz6/lF0xnu+ZgoUz81OTPiXhKxHkrJWRgrp5C5x1U4DVz9FCKn1d+DrtNqHikTJhRzYF66D8hKTA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-R3khGzugICktV6c1polHetvTW8dLGGeJzxdZOZnvR8+2qhVkyN9djtAShog21Cl+oqf0aYkfuzYX1EZxMY3dMg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.22";
        hash = "sha512-kzvfnhyQtqUChnCdel0qiQ1tED3dgyfJ6O4khIQglp7yWoGQ35jQuehXPjwRnhberyHjeO3As7hROq2KUPWvpw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.22";
        hash = "sha512-06CGHJmuQ1VRc+y81gXi+riubWwPC8dN795z14vdlN8Hzg9vcmSSPwCjYU/cHonN0EA6pnXXfraz4+P1hUeQiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.22";
        hash = "sha512-Vq8Qgi9h+neFbf/e6+iFLGgUrw2RJ+sM+9RyF9iu3QYXKtWHsrH+c/Cl8NLnK1ZeNCdYVEwPzDbZEUUV5y9Log==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.22";
        hash = "sha512-1YKWlSML3kw9KdblS4GUhwbOPb7ACKFTzIZjZEf62bDsOTVfs3b/7vNyFxPYH413T7Sei4xBufYtDW65C/jeEg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-uOxR/PG6C/qPgrVagBrVhVOdTePK4Qeve9xSxOztFWvlonDT7yjGtiztbksXqHUIZeYKXnsLKs2a/De+YREP8A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-mr78PI4WRjafFR/Dt0905fJsoe686KT5ozxbrM1rhwcrFxgcz/fhyAvqJ9Q0PP3MLsIvRSKu29QzlDUTr+ctSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-Bz1FvJ2Zqr1HnTBM5ZAq1zzVcbaMW9lUR/zwmEi5TimzWogcW+/1Ppl4DGFSeaNbQ3m3J/v7/iFARRT6v0P4Eg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-aUQyHoKENasJa8PZd2xl8UX7vr3OSBbA2Qto2GKAOrmk7OmKMM2zDLGQfQuwv8CV7LzmWDOz8khWaD+UOzkciA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.22";
        hash = "sha512-VZzH3Qgc1iDd7HqCYa1izJDyO3+XX0d4u+n/TTphQcPfaincW8QnYb3YL3IQUou6VAwKiPPcOodfJAfh7TEp2Q==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.22";
        hash = "sha512-5wBl8zEmfV82wgGIngzbnHLSDCWYh5YCC3jHYfivBnM3KsVBcUWlCcQlWBkAJM+aXrGoDVSvBMwQlOH9AR+k0w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.22";
        hash = "sha512-7FQXb9BMW4+Dil4uyregMG3dmzCYDCy9W7z7gI9SogQ9C895RNo4S3RqFY1/H3CIguiUjyrnEZtIPNHd1A2rDw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.22";
        hash = "sha512-QAqWt8fSUh4afWG4sBlJRd8BLiVe6LknBrFc8rXC/8A1zLCb40z1R+MdJ2s9dI7ggoIOoqF2PzlSAZYA/+nbOA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-7ecAbqes54zNXVHVj2O59wV9X+eK2aNVHM4qfynuVOGusbhuEeJ8Cd9YQrDJB+d5DmajW3VMbRCgQ3jCGUG0aA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-YhL2SF+LBKeQmIRbqp+T2GU7ZCA2JbsyfrZ2hK8HN7Yao5mXdtHt/A8KQERJD2GTo/RvSU5WlfwITh44HKYa5Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-x76BWuxFyAWVQ3GyuS7ujK8qYmckeOAnMPzOz2DEIxQIkjq71odV9P0AUVGuH5zkSlbOOkWIRKb1MmA7Vp73KA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-4hzg4K4pVDoNSPAvDcf5tiYEKjJHLwTrugwrQ9SEnhEQi+Wk9n3n0NutNx0jVHrOfEwroU7eg5NqKZ7uFQSMlg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.22";
        hash = "sha512-53wgkMj76mdoNGwwrtwxaVofv9pwUDDyqxDpkLB35nqaE9+9QwPUyJLdQCopeBlmyl7J5HPkWFcccMV622+b0w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.22";
        hash = "sha512-Slonq8Ylt+TtPTq/45fMquLEgX4ijueKd5/76GgrOtQ/RcdpVjFThMWOIWXeIA3xbXBDdfDOAOZXx5CjHPIjSw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.22";
        hash = "sha512-NikpKByyXlx7AKX29MbjCkJJNKvDPpcfzJK/2zzMoc6DNqLWtChXppPwPGgB1RKKFJinYutk/BXzVv7M1kt+rQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-KHOl9S9clEmOmmv4QXzJ8TbHjLCyDSke5a75ird52qtl35SYIEAJsEKRUmnb2caqYOaaJJWoHIvmnA4hAf/20Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-BuRGvNW5NRLwx6trRiozqFJBuBBJwPON3XiMP+jNIDDhdpCkaXe4OxRETuIl2HDDOgZF6DJoH4SPa+X3HV3Rpg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-QZMsUr6as8h8HB81WGQ625eJDmFnEQ9DAd6Ii1ckm3F/AC232e/cC21QKsMxB6OvutgS+7pu6aF+FyDqxqmiHw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-ZtonzYq5qaUdg5s7sQDSW8OseJ6rz4niQRZvnGariXLtj/zXxKhokv/FW7NBAoakHgT3a2am3r/mHZSoImNkow==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.22";
        hash = "sha512-UMZdvR9Ni5j07LaQtYX0G9I3ZwbrgnPhAKmZTejJI8bxycrSpozrhpe36LdTYI1COqlK8Qk8yaPqCn+Me3QbeQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.22";
        hash = "sha512-SKwNIPbZ0/BJrO5n8of8pToU4e7MT9y+T8Fd5+HYf2WJDY99z2yTVTp8numWsEcsUdhRPmtOQ/KXopIhf4TeOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.22";
        hash = "sha512-NW+7PO32O9bf1bgf+cSPMxVjn6p/PT2qrunYGRRkeEgXY5ISYdYhgAGI9JYhionr2ZqJuubbJzJXboNmqkWo+w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-zihWUjq5T3c1tZm7RB34kQHgoUuET53EcwgicMtoGgtv2Gu9tjU18IgqlFRnYmJZnjL+FV12WQRRwrhJLsKMig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-G0E80Ywx0lymKkrUCKrrkrlKGpOKOJ4O4aw2FBfP2ozgkinWUbwgTPrednCKm0429OOaXEfkxKyPj4WkC2FbRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-z21UJmi5yn5O3Ef2euSGQHl7Rp2rZREWon0LMr2okmQ7E/giPLl9lW+YZEySZ2O783Hv6ULM/WEqox3sovy++Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-FAr/fZZRWBpuaKPdR+J9hfHJfGN7YHV0JPUy3hdtQ6+PAOJuFx+NOGTMCda7RIXMnYmWNrSCr8pyJfEkXf4GCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.22";
        hash = "sha512-P0pSoY5t/kBIGyqbaYde5FE+Nf1geu8DtSMj+JsJ0CT/Zze9fuzLEdEPqk+6KnNf4esstp8RlqOrEV0SZHJjHg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.22";
        hash = "sha512-hnCPWSYSpkO0W/lke6vsVnUYZwh9UX8yqi2m4Kw3cbfoXSJjYH2+cBRQYuN3kN+FTZgKu9Ip1BVwmZREhMY0jg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.22";
        hash = "sha512-fvgxwaerisMceU2TM+BX7Fo+dc5Yz/WsQ9TsTakSuanaYFU8l118BNr0l+e7InYK6IqSvYgYrhwMX8sc1Q92sQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.22";
        hash = "sha512-ww1g5bamBhGlfrC8YZRr2oKCE1lTvqF4rDN18IY8ZikoFyVRBEdeR88U50wp51rOrI+K1vTHRJqhHlBoJbY3+g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-/By9AXmAreSBCZmHzd1VrvOUYi8ZddE+FnTOgjWFSIMV4aXUPnd+7Y4ACzJ463MbPFmxdYU1LY2AK1SZrvjxlg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-7cRC0sZ4A2181yMUNZO+AeMfsuE/7Ky8I7H/AzKRXEzXUxwxTZcpZ2VvuUc1ZIWcKTlbpFIVlHUfw8LGCoJ/vQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-U0HQ9BpGQ9alc4koZGS84r54AbhZi9GWUXtfun+WkbBxQj01ZdekVKSXZYF3eZzovxeibDD6S0J+wlCu228BHg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-R+kC8pkRojexTSQkfxSLMc14DG4lfvGSy5CXjzPn5oA9GdU5yizX3yuzh2k1K+e/XMYGr+C0GTJSc95ABbGc7Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.22";
        hash = "sha512-AXSAtKsO1DQkNCcgvUe1l8VkjjndnxmcaZ+jdaNX3Jgw2jXeRA3X37/vNzLemNk9AJ+QjDbCpsGPw3R8EMxEjw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.22";
        hash = "sha512-56rBSqyRmg82QHmFHvGLCAsmaZZ+hkwO7pGRLgH00OLU2RqqgcXVnIogDHp5DI5bB6lqFnen9E8E155mTM28gw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.22";
        hash = "sha512-jV0BqDlZMdnbyefPVy5/KGkHLY1WJSmm6T9PzjVHD/cilAoE/ytakxGsGYxeWgxMeThbC9iZGxFTmvoyOxBjlQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.22";
        hash = "sha512-+HfuYLBKq0MKHbVUF2A76/MWzAs0fG/Sg92on5sW0KEEHhRiPZyeb+sK/Xu/WxLmacqLfgdcNPAfezafiaP7pQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-9BUL0gmuffw4+2A+p5VjEwauybqfUepjVyz5kuR+N1Q9Ov8OgiGXOunU/20A3666vgI7NO8+zn98FzR/58jVXw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-t+j5YWw0Qt+ayvfzx6rgcB/CRVxcJn2H11+gUGTv3P7ZGMSm5E6RfEsCWZPhED4cSEfzSsk1oHg9f4Oc2ac1vg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-SXGeJlwrpZVltqnO772i5CAwhRuH68R++ILH3DOZMebTn7vVH/Al8xX5yqABqLN3EK+HKIa9+PGLkd1t02Z/NQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-q64/J1KOTLiv4AxaXjzjzSMwSfYeGPEWehXuGx7WoIEV2q9p9a2okLhNwEbIUL15TgiyoAU989Hgtxg85K+ThA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.22";
        hash = "sha512-9KJky9y6KsJEJZUdXKD3tS4B8EWAvn90X3kYAQXo0ONerQ3qJaodSnA3x56gaq/ZyfUYzKKak5wyHJdhxkXdtQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.22";
        hash = "sha512-ayoV3Etv3YITfRDlutZYSWe1jWNfQe0gUGAjOBxvmdBHp0ixIKOmNkfOdzHLBppRIcW3pkPES57Xs+r3INXLoQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.22";
        hash = "sha512-9C0VmxdJ9EJz158E7aQl8zafkkNzP19ykFRueFl6ePMwgABuF/FTMqWAllEn8R+bTC/pEAErV6gE7+TdCxj7fA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.22";
        hash = "sha512-/d3yITHpxm7cYy0WCg96Ounh5jAU12OnAgBGdIPxZvf3P3v73O68QakDTzQDLgBIFCNz/zHz3aQ8Dna1aJZyGQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-CRsJczkfEnFq1YZ/tz4YF8s/rRms3JX6WyyqHhipxLam9TYcOfl+Fy/Kby4bIBNbz3hUyiA93gYBA5HvmsrHSg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-R+7mpfsKGZlIVtwHySDPq9tpEfywmiZQsfbvdelzU7KIYHl/vCjOEL1oSFVU/4K4X4cix0RmV75pV+koi214Yw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-Zm519OLIH/zPbsi5wzz6qrUwLpAwb8DkP7p//OKDgNJJqsTlMxyj6i8v6zfLS0TqMcva069nKplxOue3pK1EMw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-l0xPJk4lFJZ8678XknRO541VFxTFUO/2hYdDVu3h0P7otHgc0KdsIBJ+ApOSiKOHOK/258wHlcy8R1cnKlqy1g==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.22";
        hash = "sha512-CL6gz7brE8sj5G4Z+G4zlNT/58jkhWJVGIiQ2A2RJQV1csuzZhNg2+WwGsW1rptCN9Wz3cvDKU8h1aWl3sz6Pg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.22";
        hash = "sha512-9cccvdEsP+vKE3q6o+HaE5BzW+VPF8lKfqWltpZms4KnRYKHkIiRgzoYsy48JW76IYJ2Uy/+tI2CeJ0q6IGYaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.22";
        hash = "sha512-DY1llnrMNLD3SS8jICF0o4vu/irRvaW8BpTj33Es1DygrQD5xkV1yXn6OceJLGaIdSn0RSoXJtlH4/iXBKi4gg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-p9qRfz8NMlz+lj+BkCaPEsfra+hhgxnA3A0ljRUUYOZJWXNWxFslhH7VYWPx41NX2KLjNUIBBnrysigdrYLmsA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-PLQuSqVx35MJICMC6N7WZQoeeqDgYMKwi+ivMD50C0sn7jUSEmgAQ1xVEZgNbhRO8P0hidTFbuu3ph3sCLU3UQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-LettCeXpFNTQUN3EjbG5qTG7y/kjWNXqrhrfN2M9x+g5LFOIn4nTTxeOR/SHIl/LpaZ7OVTDzjRfbDlePieHpA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-ajokQ1QT2f+hu3udmW1gStsMGmjMLCj03eBg7jT4ucmgA8i+sI6y/craK1LteVMOWsES3tgUrVk6YprSM0H0BA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.22";
        hash = "sha512-+wAYzRrhzixvuxMeGvvXjAV8UpqE8YmkxEEV7FpL8jDn2NsLD7QBTuxuHI2Kt2mA6mErjSen5HAOiktNYds5Fg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.22";
        hash = "sha512-eTg3m3FUXRZz0TIvvY5Nu5Cw3u2ZpoaU5L1r6ShybqOHHaPFIEGQ/H7nl6fBIw75uuaEsZ2ccb7/ZU83bsBoWA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.22";
        hash = "sha512-L4V79u5Jjn1vEv1fPZhpthhnCcDh9qx4lYC+scY1u2cVve+IfJr793m9DZNLMSQ0eu2QOdxzDqAfq91JXqIVHA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.22";
        hash = "sha512-3jO/sRwGJSPi4CWMph2KAAvKu2I3xL8MVgMgzXYKWutyG8Y9+r6cdxIA6F+kUeFdqJKSzaYPfI4XlL+goUENLQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.22";
        hash = "sha512-aUVz2845Op68QcUENBdY0LIkh6wZYBCW0/6i6mNtCWkJ/iOWaKYyBVs+TAEcUAXsrdK70FJV/8+gSVmZ8MqzXA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.22";
        hash = "sha512-4jndbhSGbY++TkPMF8Fak3fRkKEqG8mUUjUd1Y9E8tDALNoWlCdcSdLJHUWl4V3gr3pWPaxffJOViBBgrVwjWA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.22";
        hash = "sha512-sX6BNH9ixFzzzV9v2mNRtr7pKLA+ViTohVZqdFDpCFxp+Ql8poevGyu+ETByFuZIVfYAUHg0BfZcSxbBWsQlfg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.22";
        hash = "sha512-KmBckVLtH/fh1Q1aef6YPTNbvxQU+6yxg3uRUy16j6KCmKIc7Mq3oNojt2dyiUOcAxcxgbVH5maQPVL2EtTWhQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.22";
        hash = "sha512-2q0/5BIrkQGc/2fu+0LKqBL+x3N7eeKb3ErJhNz/azmWGRE9rqcxC9bY4rHA363ZuJ8vi1c7NUAp1+P3TZUK2w==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.22";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.22";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-linux-arm.tar.gz";
        hash = "sha512-qVNRY43sjUst6XK3+/yt02KuoEnJkB6Cf8fMlvJfm6+xcaxHQuFqalEGoDuZ8OsOb4DXTiUWnJaJ5/1fB7xC5g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-linux-arm64.tar.gz";
        hash = "sha512-U463zmLHfzg2BpBvOPmqmREznCrU7oScX7VSSRwbyBJJI5Xyl1UQ64CEECY7rwbwdxx8rwtGaVJR5sknMREojw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-linux-x64.tar.gz";
        hash = "sha512-hC+4lubUlodc1rtpQ3ecqKepaEFw1yALerK1NDOqFRqaGACZj52lWCI3ppCZbYFogi5QuNS+jPmlEsvnoiQOiA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-linux-musl-arm.tar.gz";
        hash = "sha512-UZVjPxgk2GQX2hfc+AHDXTwYccWTn1OGjkSdb39VIcelvE2TRirhYZyCuSAnFauIcWdXi4f7XMkfSkA2bP2xpQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-linux-musl-arm64.tar.gz";
        hash = "sha512-UnFj9+rHA9CNiTFzmHfEd5nQsnvT5QiwkxUYsYrvmTDq4YxpfH/eS0MZxlYCq32eZzP/hvPlGxBZ9C9X+AwmiA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-linux-musl-x64.tar.gz";
        hash = "sha512-BWA0DnvHWidtbfedqfAThaahRSfYVZ+trpn2cEt24mSc4FNklJ/EYXWfozqY9YyNpejiUeS5PPYPFp2xXinqfA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-osx-arm64.tar.gz";
        hash = "sha512-GJHJwwmNAT3MdTZYUXsnW59OwNDPMO1K5fV3o0x7ql8oBTZCSOK5QV3Lc5YkUsasxKklNJTMJ1lOhx5NV5I1IA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.22/aspnetcore-runtime-8.0.22-osx-x64.tar.gz";
        hash = "sha512-nUMZ0Nkej9XUuF35R050of35N3csaN4nlzfqfXsWGQwVMVS0r48Gfqwj4xipkCNKEsIqtjpQmsMpdqLqJ/GHbQ==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.22";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-linux-arm.tar.gz";
        hash = "sha512-nZ5ibAzcxoTkclK14c8KqRmTeAvvgbQYHw6zPcD/E4hJlwhj91bunJ28ixL2R/Tahz6SODrPK4ll78C2pi5oUA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-linux-arm64.tar.gz";
        hash = "sha512-WgEtmF54LZEptvi5TZb2bakzNgXgEaFGf3Jwuko+BKj8Aq23lplBa4N6OtBA+/nPsvrCEC8wOOa1yO2Jil2a3Q==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-linux-x64.tar.gz";
        hash = "sha512-jyDbn3ctAUgmH1+0UXysf9Q8xapXEU3+prlVYoZmNWpI8qK5nOz1elTLBj/niPP8OpXdHwXFfCK7kYp9dZRjWg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-linux-musl-arm.tar.gz";
        hash = "sha512-VEU+H0bE/xsyW1dJXUf2NfkpIB18gGC6QSxEj7K9EBw0MGSvTC/dcjpvgJhrAaDKjv1hybTSGKIB9NaI55dlCQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-linux-musl-arm64.tar.gz";
        hash = "sha512-WMO5Bwz5ne0M4PgIys97EOFd/V+HTLCSaZIedv8FOQwOYh5TIMJwErmOBBgNc8gNIGO7vX17qxegmdD+7TDKHw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-linux-musl-x64.tar.gz";
        hash = "sha512-cneuVWkxeYeqdEQtbgd/xlpwQl7Kd/En4uFJ0WUl7J+KjKC1rLdz7n3R7mQyBNyXnURR3y+W5FXUgi02Etqlgg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-osx-arm64.tar.gz";
        hash = "sha512-Q8fXcFIW/PMpbaoh9YhAO3pnaKIU6qZPNWK/ZjmQdF78m3rDdFaICykcwbbcOhVo0hPpcAbrz8yM3ZohNSLC2Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.22/dotnet-runtime-8.0.22-osx-x64.tar.gz";
        hash = "sha512-GG7RDRfsQ1O3PpVNLAVnMueWK8fPMVy0O+4oEPRUgmTPMygzN8+9LX6S2PV7JM+M//ejs8lQP4jKK1rZphuNmA==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.416";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-linux-arm.tar.gz";
        hash = "sha512-jxfrmMMiChu6nwrWaSAQobKcmAt00/9xKTdkBLEAMeJ3p4Dr/V+riwHW8IgcOFjjRkHkUkYV17I3wYd0BCLL2Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-linux-arm64.tar.gz";
        hash = "sha512-57Ce5wpieWTfAKSJtEd4K//pzTRD+wqO6ugQX8wJGaaNPJIAjx3r5n31sq5mkKuNZXxQJryVC4iiU7QpDF+Apw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-linux-x64.tar.gz";
        hash = "sha512-Yzy4VnPjUZyCVTL3gPZ1D/JO0kjvjfaIhVQOUQtVm2rcLI2UDkw0n8DPLJyvGE8e/qzLxelS1uQ189oCfK5BiA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-linux-musl-arm.tar.gz";
        hash = "sha512-AcGARiVXlVbH+fXk4/eRcsOgBl31YNKNsYWwZsVz1R9my6RRN1BrCvPVEyLfgcqLXy7qX+DcPqe9wI8qhckAEw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-linux-musl-arm64.tar.gz";
        hash = "sha512-1f0d6UvE6EhTsYtt9WjVoJuLffCjXH6UZaFhZ9KS4c9SgeEO6LKK/EY8SFMFBxuEq98Pk98Hi3LjsZ/rG/7TEA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-linux-musl-x64.tar.gz";
        hash = "sha512-gaMRpRt9bBN5hXEcUBsdkJ9xkZMZtTCqey2kkQJJtN9jHRlvW3t6NwEdEv8XlsJW/sRiJmWOlE1LFTwk8pk3zQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-osx-arm64.tar.gz";
        hash = "sha512-Dsa1FiXowyOBdOGy6HWc4dZMBmiK7paAZi/+LN0rCJjoyB0lydE0qJlftTqyw0MScAh/sHnPMnuoBFCR+/GWFA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-osx-x64.tar.gz";
        hash = "sha512-YDi/PxdmYZcYYcRlSZQIlsAJShvtj+l1QnBqE8hY3PZrZ1EuQQjHIZbdFNpdulqTGOTjM5HppdF2lMtMKFWahQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.319";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-linux-arm.tar.gz";
        hash = "sha512-ocH4QXl/qREmH8JwAr13krCaSoPQGxBDCEJu0JDC0rUsBlZXMGX/CRqmIdV6cVFrYR4E14iQuhuUH/QU7G6DzQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-linux-arm64.tar.gz";
        hash = "sha512-QhPJDbRC5WEaukQ1KP1QOH3rMfR85MsV0QKeDAzAQHr8FU6xdg2v610uk7I0SHo5v3XTN6tbFS+V1thHcS9K4A==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-linux-x64.tar.gz";
        hash = "sha512-OMIStSfzaALIlvR7xPLf2kmFEcLVzAgA2b3e3601oQqIwLUHK7CrUNBdg74KVxNJgnqGzHp8PazmfU2WtvRt8A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-linux-musl-arm.tar.gz";
        hash = "sha512-ASxtDl6ClQ6UyFw1MWENJevOGiklezo4FQ7PjV6gPk9JfniHQ35xuAMXC5RCrIXe4dFpf99qTK1Z4EJg5c8/Ag==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-linux-musl-arm64.tar.gz";
        hash = "sha512-UVgcHr+Ec8EQrZiCNjEPJjwSuBXD/TXfLVd0v4JsnLdYwD2tiQRP1LBdPbj0j+t4CemoYPx3RO+GtuTE8mg7tQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-linux-musl-x64.tar.gz";
        hash = "sha512-LoqmFhLEDl33yq1S+bwMcZW6JYUBFRKrn88nYrSlkP/G+0bCyDmSnoWUwdtBVLeh93gjQU8wUrWv4/qazWeUbQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-osx-arm64.tar.gz";
        hash = "sha512-gnYRhItOKEZHna8gKW0VY3fCW5Nz77OLdKC/kXpfMFgGmzvtxvz9R16pbGUmu43i4zh8phTlEvojapcLY51Gpg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.319/dotnet-sdk-8.0.319-osx-x64.tar.gz";
        hash = "sha512-zU5FhXWrWXkNROthjHD0BOTBIGT/82ehgD6mRCVGK0hAmsBze3oH7E7DrqdYE63yJf8en0csWozSNyhtqAQk5Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.122";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-linux-arm.tar.gz";
        hash = "sha512-0lNIY9TwKJQ/wi0Fnl/EQSQTurHu9lMpb+kDAWgQRkPmeUonjBAQ/fZv/cMoWMyfwFYqOGUeZKBamEM6g654wQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-linux-arm64.tar.gz";
        hash = "sha512-Xn+c1vhaQOp4+k3ZwSErhqQT4pZsGiDdiYTiyNvkWorJbV7Xct4y1GI4MtIGACBfviX/kBf2T6IfuVr+YXBoyg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-linux-x64.tar.gz";
        hash = "sha512-M2zC4D/jMtshSVX0uH0RIvCGB2OOcTifsrswMNyf2i1WL9hipHGV+Wt9mPNMYwaShjx4hdLLcO5Cqkbote9dpg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-linux-musl-arm.tar.gz";
        hash = "sha512-1It52GHKM3EAlBlQ0EM6aEgdXRy/m9hptTGA3+7Np4BWV26QvSj7tQo9gqzCo550sceWA6A56BCj+vN99LnJ+w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-linux-musl-arm64.tar.gz";
        hash = "sha512-16Vl0NxaGka19H+j8mhgC5vSo2IprP0OjoUP7ZlKvWhr6ovIsd8CVtaVuvHLT9BzfAkcVLgnrdQNCqa5FxTRog==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-linux-musl-x64.tar.gz";
        hash = "sha512-1P5asgSDEzS3Qt9sZXzCobSVNBpbxSMDFY4glqvyadvieW/wbzZOLwRbJTS1kh9fXNbjDZEXKaGyVjQbojL4Gw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-osx-arm64.tar.gz";
        hash = "sha512-KGpNaYI+2RvcdbriXDJrN0FQOnhoP06wmpd97gZceSlzTnbGOXRgnubqHzN2TZgCWaBLdqOsDS0J9KDUFz2OiA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.122/dotnet-sdk-8.0.122-osx-x64.tar.gz";
        hash = "sha512-QV8LCIinx3iBZ63civsZyIVVXpPkLWBeEM+RHBw1b637rgmJM1nvcC1ayRgUccNp/ySBSJr2zcQMRI/uwL1IMg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
