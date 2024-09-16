// taken from https://aur.archlinux.org/cgit/aur.git/tree/libuosdevicea.c?h=wechat-universal

/*
 * licensestub - compat layer for libuosdevicea
 * Copyright (C) 2024 Zephyr Lykos <self@mochaa.ws>
 * Copyright (C) 2024 Guoxin "7Ji" Pu <pugokushin@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 */
#define _GNU_SOURCE

#include <string.h>

#define declare_string_getter(suffix, constant) void uos_get_##suffix(char *const restrict out) { if (out) strcpy(out, constant); }

declare_string_getter(mac,      // MAC address with colon stripped
    "000000000000")
declare_string_getter(hddsninfo,
    "SN")
declare_string_getter(hwserial, // MD5 of hddsninfo
    "92666505ce75444ee14be2ebc2f10a60")
declare_string_getter(mb_sn,    // hardcoded
    "E50022008800015957007202c59a1a8-3981-2020-0810-204909000000")
declare_string_getter(osver, 
    "UnionTech OS Desktop")
declare_string_getter(licensetoken, 
    "djEsdjEsMSwyLDk5QUFFN0FBQVdRQjk5OFhKS0FIU1QyOTQsMTAsOTI2NjY1MDVjZTc1NDQ0ZWUxNGJlMmViYzJmMTBhNjAsQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUE6ZjA3NjAwYzZkNmMyMDkyMDBkMzE5YzU2OThmNTc3MGRlYWY1NjAyZTY5MzUxZTczNjI2NjlhNzIyZTBkNTJiOTNhYzk0MmM3YTNkZTgxNjIxMmUwMDA1NTUwODg4N2NlMDQ4ODMyNTExY2JhNGFiMjdmYzlmZjMyYzFiNTYwNjMwZDI3ZDI2NmE5ZGIxZDQ0N2QxYjNlNTNlNTVlOTY1MmU5YTU4OGY0NWYzMTMwZDE0NDc4MTRhM2FmZjRlZGNmYmNkZjhjMmFiMDc5OWYwNGVmYmQ2NjdiNGYwYzEwNDhkYzExNjYwZWU1NTdlNTdmNzBlNjA1N2I0NThkMDgyOA==")

int uos_is_active() {
    return 0;
}
